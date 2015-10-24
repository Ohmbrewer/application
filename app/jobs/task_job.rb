class TaskJob < ActiveJob::Base
  # Note that this is the default task queue.
  # Our ScheduleJob should probably set a more specific
  # queue when creating the TaskJob.
  queue_as :task

  # Processes a given Task
  # @param [Task] task The Task to process
  def perform(task)

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
      last_check = task.equipment_statuses
                       .updated_after(task.updated_at - 30)
                       .last

      unless last_check.nil?
        # Got the first status update

        if task.stop_time > Time.now.to_i
          # In the holding period.
          # Let the task dictate what should be happening.
          task.do_ramp(last_check)
          return if task.failed?
        elsif task.stop_time <= Time.now.to_i
          # Passed the ramping period. If we haven't failed out, this is a success.
          task.ready!
          return
        end
      end

      sleep 15 # Then take a nap...
    end
  end

  # Processes through the Holding state (iff in the Holding state)
  # @param task [Task] The task to process
  def do_holding(task)
    while task.holding?
      last_check = task.equipment_statuses
                       .updated_after(task.updated_at - 30)
                       .last

      unless last_check.nil?
        # Got the first status update

        if task.stop_time > Time.now.to_i
          # In the holding period.
          # Let the task dictate what should be happening.
          task.do_hold(last_check)
          return if task.failed?
        elsif task.stop_time <= Time.now.to_i
          # Passed the holding period. If we haven't failed out, this is a success.
          task.duration_reached!
          return
        end
      end

      sleep 15 # Then take a nap...
    end

  end

end
