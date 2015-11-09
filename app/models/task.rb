require 'rhizome_interfaces/sprout/sprout'
require 'rhizome_interfaces/equipment/equipment_states'
require 'scheduler/state_machines/task_state_machine'
class Task < ActiveRecord::Base

  include RhizomeInterfaces::EquipmentStates
  include Scheduler::StateMachines::TaskStateMachine

  # Tasks are organized in a tree structure representing
  # the order they should be run in.
  has_closure_tree

  belongs_to :schedule
  belongs_to :equipment
  has_many :equipment_statuses, -> { order(created_at: :desc) }

  # == Subclass scopes ==
  # These scopes make so anything that references Equipment generally
  # may also reference each of these subclasses specifically, automagically.
  scope :turn_on_tasks, -> { where(type: 'TurnOnTask') }
  scope :turn_off_tasks, -> { where(type: 'TurnOffTask') }

  # == Serializers ==
  # HashSerializer provides a way to convert the JSONB contents
  # of the :update_data column into a Hash object
  serialize :update_data, HashSerializer

  # == Special Attributes ==

  # This enumerates all the statuses our various Task types support.
  # See the State Diagram or the TaskStateMachine module for more details.
  # We leave it up to the particular Task subtype and the TaskJob to manage
  # *how* the Task transitions between them.
  enum status: {
      queued:       0,
      started:      1,
      message_sent: 2,
      ramping:      3,
      holding:      4,
      done:         5,
      failed:      -1,
      resending:   -2,
      overridden:  -3
  }

  # This enumerates all the events our various Task types support for triggering off of.
  # See the State Diagram or the TaskStateMachine module for more details.
  enum trigger: {
           on_started:      0,
           on_message_sent: 1,
           on_ramping:      2,
           on_holding:      3,
           on_done:         4,
           on_failed:      -1,
           on_resending:   -2,
           on_overridden:  -3
       }

  # This gives us a way to store the data that will be sent with *all* updates.
  # Subclasses that have additional update data to send will have
  # additional store_accessors
  store_accessor :update_data, :state, :stop_time

  # == Validators ==
  validates :duration, length: {minimum: 0}
  validates :equipment, presence: true
  validate :event_and_parent_validation

  # Ensures that the control pin and the power pin are set to different values or no value.
  def event_and_parent_validation
    if parent_id.nil? ^ trigger.nil?
      errors.add(:trigger, ' may be not set unless the Parent Task is specified.') if parent_id.nil?
      errors.add(:parent_id, ' requires a trigger event.') if trigger.nil?
    end
  end


  # == Instance Methods ==

  # Sends the Task to the Rhizome
  # @return [TrueFalse] Whether the delegated call was successfully transmitted (bubbles up)
  # @todo Remove hardcoded return value when Task is ready to be tested against real Rhizomes / vise versa
  def send_to_rhizome
    equipment.send_update(to_particle_args)
    Rails.logger.debug "Would have sent: #{to_particle_args}"
    true
  end

  # Converts the stored JSON update_data fields into a
  # something the Rhizome will understand
  # @abstract Task subclasses *might* need to override this to function
  def to_particle_args
    {
        current_task: id,
        state:        state,
        stop_time:    stop_time
    }
  end

  # Updates the Task based on the Status supplied.
  # @abstract Task subclasses must override this to function
  # @raise [NoMethodError] If not supplied by the subclass
  # @param status [EquipmentStatus] An EquipmentStatus update
  def process_status(status)
    raise NoMethodError, 'Tried to use the base Task class!'
  end

  def type_name_display
    type.gsub('Task', '').titlecase
  end

  def trigger_name_display
    trigger.gsub('on_', '').titlecase
  end

  def queue_name
    if equipment.nil?
      raise NotImplementedError, 'No queue name generator specified!'
    else
      "#{equipment.type}_#{equipment.rhizome_eid}"
    end
  end

  # Blocking Tasks do not allow other Tasks to override them
  # @return [TrueFalse] Whether the Task is a blocking task
  def blocking?
    false
  end

  # The last status update sent for this Task
  # @param [Integer] window Number of seconds ago to include in the scan (optional, defaults to 30)
  # @return [EquipmentStatus] The last status found or nil if no statuses have been sent in that window
  def last_update(window=30)
    equipment_statuses.updated_after(updated_at - window).last
  end

  # == Class Methods ==
  class << self

    # The EquipmentStatus variant to watch for notifications of
    # @abstract Task subclasses must override this to function
    # @raise [NoMethodError] If not supplied by the subclass
    # @return [EquipmentStatus] The EquipmentStatus subclass to watch for updates of
    def status_class
      raise NoMethodError, 'Tried to use the base Task class!'
    end

    # TODO: Move this out into a table of available Task Types
    # The list of supported Equipment types
    def task_types
      %w(TurnOnTask TurnOffTask)
    end

  end

end
