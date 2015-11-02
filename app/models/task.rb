require 'rhizome_interfaces/sprout/sprout'
require 'rhizome_interfaces/equipment/equipment_states'
require 'scheduler/state_machines/task_state_machine'
class Task < ActiveRecord::Base

  include RhizomeInterfaces::EquipmentStates
  include Scheduler::StateMachines::TaskStateMachine

  belongs_to :equipment
  has_many :equipment_statuses, -> { order(created_at: :desc) }

  # == Subclass scopes ==
  # These scopes make so anything that references Equipment generally
  # may also reference each of these subclasses specifically, automagically.
  scope :turn_on_tasks, -> { where(type: 'TurnOnTask') }

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
      scheduled:    0,
      message_sent: 1,
      ramping:      2,
      holding:      3,
      done:         4,
      failed:      -1,
      resending:   -2
  }

  # This gives us a way to store the data that will be sent with *all* updates.
  # Subclasses that have additional update data to send will have
  # additional store_accessors
  store_accessor :update_data, :state, :stop_time

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

  # == Class Methods ==
  class << self

    # The EquipmentStatus variant to watch for notifications of
    # @abstract Task subclasses must override this to function
    # @raise [NoMethodError] If not supplied by the subclass
    # @return [EquipmentStatus] The EquipmentStatus subclass to watch for updates of
    def status_class
      raise NoMethodError, 'Tried to use the base Task class!'
    end

  end

end
