require 'scheduler/state_machines/batch_state_machine'
class Batch < ActiveRecord::Base

  include Scheduler::StateMachines::BatchStateMachine

  has_one  :recipe, dependent: :nullify
  has_many :rhizome_roles
  has_many :rhizomes, through: :rhizome_roles

  accepts_nested_attributes_for :rhizome_roles

  # == Callbacks ==
  before_save :make_ready,
              if: Proc.new { |b| b.not_ready? && b.profiles_assigned? }
  after_destroy :remove_recipe

  # Enumerates the states a Batch may go through
  # @see Scheduler::StateMachines::BatchStateMachine
  enum status: {
                 not_ready: 0,
                 ready:     1,
                 running:   2,
                 stopped:   3,
                 done:      4,
                 error:     -1
               }

  # == Validation ==
  validates :recipe, presence: true
  validate :sufficient_rhizomes_validation, on: :update

  # Ensures that there is one Rhizome for each Role
  def sufficient_rhizomes_validation
    unless profiles_assigned?
      rhizome_s = recipe.schedule.equipment_profiles.length == 1 ? 'Rhizome' : 'Rhizomes'
      errors.add(:recipe, "requires #{recipe.schedule.equipment_profiles.length} #{rhizome_s}")
    end
  end

  # == Instance Methods ==

  # The estimated time the Batch will be done.
  # @todo Refine estimated stop time. It massively overestimates, currently.
  # @return [Datetime] The estimated stop time
  def estimated_stop_time
    result = 0
    recipe.schedule.tasks.each do |t|
      result += t.duration + t.ramp_estimate
    end

    start_time + result.seconds
  end

  def profiles_assigned?
    rhizome_roles.length == recipe.schedule.equipment_profiles.length && rhizome_roles.none?{|r| r.rhizome.nil?}
  end

  def remove_recipe
    recipe.destroy
  end

  # Determines if the Rhizomes that will fill the Roles for the
  # Batch are currently in use by another running Batch.
  # @return [TrueFalse] Whether the Batch's Rhizomes are in use
  def rhizomes_in_use?
    rhizomes.any? { |r| r.batch != self && r.in_use? }
  end

  # Provides a human-readable name for the Batch
  # @return [String] Batch name
  def name
    recipe.name
  end

  def queue_name
    "batch_#{id}"
  end

  def available_role_options
    recipe.schedule.equipment_profiles.map { |et| [et.name, et.id] }
  end

  # Tries to start the Batch
  # @return [Array] Single key-value pair indicating success and the message to display to the user
  def attempt_to_run
    if recipe.schedule.runnable?

      if rhizomes_in_use?
        [:danger, "Could not start <strong>#{name.html_safe}</strong> It appears the requested Rhizomes are currently in use!"]
      else
        rhizomes.each do |r|
          r.batch = self
          r.save!
          Rails.logger.info "Assigned Rhizome #{r.name} to Batch #{r.batch.name}"
        end
      end

      self.start_time = Time.now.to_datetime
      result = ScheduleJob.set(queue: queue_name).perform_later(recipe.schedule)

      if result
        start!
        reload
        [:success, "Starting <strong>#{name.html_safe}</strong>"]
      else
        [:danger, "Could not start <strong>#{name.html_safe}</strong>!"]
      end

    else
      [:danger, "Could not start <strong>#{name.html_safe}</strong>! " <<
          'There is something wrong with the Batch\'s schedule that ' <<
          'needs to be fixed first. ' <<
          'Make sure you have set a root task and that it saves with no errors, then try again.']
    end
  end

  # Tries to stop the Batch
  # @return [Array] Single key-value pair indicating success and the message to display to the user
  def attempt_to_stop
    recipe.schedule.clean_up_task_jobs
    self.stop_time = Time.now.to_datetime
    rhizomes.each do |r|
      r.batch = nil
      r.save!
    end
    stop!
    [:success, "Stopped <strong>#{name.html_safe}</strong>!"]
  end

  def status_label_color
    case
      when running?
        'danger'
      when ready?
        'success'
      when not_ready?
        'warning'
      when stopped?
        'info'
      when error?
        'default'
      else
        'primary'
    end
  end

  # == Class Methods ==
  class << self

    def brewable_options
      {
          Beer: BeerRecipe.available_recipes_options,
          Distilling: DistillingRecipe.available_recipes_options
      }
    end

  end

end
