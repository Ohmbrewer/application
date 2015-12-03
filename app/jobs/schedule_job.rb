class ScheduleJob < ActiveJob::Base
  # Note that this is the default schedule queue.
  # Our ScheduleJob should probably set a more specific
  # queue when creating the ScheduleJob.
  queue_as :schedule

  # Processes a given Schedule
  # @param [Schedule] schedule The Schedule to process
  def perform(schedule)

    Rails.logger.info '======================================='
    Rails.logger.info "Starting schedule \"#{schedule.name}\"!"
    Rails.logger.info '======================================='

    # Launch the root task. All other tasks will be launched via triggers on the state machine.
    TaskJob.set(queue: schedule.root_task.queue_name).perform_later(schedule.root_task)
    Rails.logger.info "Queuing root task: #{schedule.root_task.type} ##{schedule.root_task.id}"

    # While there are more tasks to perform, we'll keep on performin' them...
    until schedule.all_tasks_complete?

      # # Override any tasks that are blocking a triggered task.
      # # We should end up with the last possible task.
      # # Note: This will short-circuit any triggers after the current state,
      # #       which may mean some Tasks down the line won't get triggered!
      # #       Hence, if we know a task will override we should make it the
      # #       parent rather than the task it will override.
      # schedule.queued_tasks.each do |task|
      #   # Stop the overridden task (task in the named queue with the oldest run_at time)
      #   overridden_task = Delayed::Job.where(queue_name: task.queue_name)
      #                                 .order(run_at: :desc)
      #                                 .first
      #
      #   # Don't dequeue a blocking task
      #   next if overridden_task.blocking?
      #
      #   Rails.logger.info "Dequeuing overridden task: #{overridden_task.type} ##{overridden_task.id}"
      #   overridden_task.override_and_dequeue
      # end

      # Requeue any tasks that have failed
      schedule.failed_tasks.each do |task|
        TaskJob.set(queue: task.queue_name).perform_later(task)
        Rails.logger.info "Requeuing #{task.type} ##{task.id}"
      end

      # Take a nap...
      sleep 15
      schedule.reload

    end

    schedule.batch.finish! unless schedule.batch.nil?

    Rails.logger.info '======================================='
    Rails.logger.info "Finished Schedule \"#{schedule.name}\"!"
    Rails.logger.info '======================================='

  end


end
