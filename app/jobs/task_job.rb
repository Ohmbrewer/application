class TaskJob < ActiveJob::Base
  # Note that this is the default task queue.
  # Our ScheduleJob should probably set a more specific
  # queue when creating the TaskJob.
  queue_as :task

  # When the Task is pulled from the queue, it needs to be started.
  before_perform do |job|
    job.arguments.first.job_id = job_id
    job.arguments.first.start!

    Rails.logger.info "Starting job #{job_id} for task #{job.arguments.first.type} ##{job.arguments.first.id}!"
  end

  # Processes a given Task
  # @param [Task] task The Task to process
  def perform(task)
    task.reload

    # If we're restarting the task, we don't want to resend it
    task.send_message! do

      # Transmits update to Rhizome
      unless task.send_to_rhizome
        task.failure! # TODO: Add restart handling
        raise RhizomeUnresponsiveError
      end

    end

    # This is the big branch-point in the state machine,
    # so we'll give it its own method.
    message_sent_transition(task)

    # If we've failed, we'll punt to whoever
    # sent the task in and hope for the best
    unless task.failed?

      # Hold / Ramp if necessary
      until task.done? || task.failed?
        do_ramping(task)
        do_holding(task)
      end

    end

  end

  # If the job itself fails (as opposed to the Task), let's wait 5 seconds and try again
  # @param [Time] current_time Current time
  # @param [Integer] attempts Number of attempts before giving up (ignored)
  # @return [Time] The time to reschedule the job
  def reschedule_at(current_time, attempts)
    current_time + 5.seconds
  end

  private

  def message_sent_transition(task)
    case
      when task.ramps?
        task.start_ramping!
      when task.holds?
        task.start_holding!
      else
        task.message_acknowledged!
    end
  end

  # Processes through the Ramping state (iff in the Ramping state)
  # @param task [Task] The task to process
  def do_ramping(task)
    while task.ramping?

      if task.stop_time > Time.now.to_i
        # In the ramping period.
        # Let the task dictate what should be happening.
        last_check = task.last_update(30)
        task.do_ramp(last_check) unless last_check.nil?
        return if task.failed?
      elsif task.stop_time <= Time.now.to_i
        # Passed the ramping period, but didn't transition...
        task.ramp_failure!
        return
      end

      sleep 15 # Then take a nap...
    end
  end

  # Processes through the Holding state (iff in the Holding state)
  # @param task [Task] The task to process
  def do_holding(task)
    while task.holding?

        if task.stop_time > Time.now.to_i
          # In the holding period.
          # Let the task dictate what should be happening.
          last_check = task.last_update(30)
          task.do_hold(last_check) unless last_check.nil?
          return if task.failed?
        elsif task.stop_time <= Time.now.to_i
          # Passed the holding period. If we haven't failed out, this is a success.
          task.duration_reached!
          return
        end

      sleep 15 # Then take a nap...
    end

  end

end
