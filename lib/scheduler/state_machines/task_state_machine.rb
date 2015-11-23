require 'aasm'
module Scheduler
  module StateMachines
    module TaskStateMachine

      # We're providing self.included to insert the AASM definitions
      # into the including class's Class Methods.
      def self.included(base)
        base.send(:include, AASM)

        base.send(:aasm, column: :status, whiny_transitions: false) do

          # These states must match the statuses of Task::status and Task::trigger
          state :queued, initial: true
          state :started
          state :message_sent
          state :ramping
          state :holding
          state :done
          state :failed
          state :overridden
          state :resending

          event :start do
            after do
              unless equipment.nil?
                Rails.logger.info "Loading #{type} ##{id} from the queue for " <<
                                  "#{equipment.type} ##{equipment.rhizome_eid} on #{equipment.rhizome.name}"
              end
              unless thermostat.nil?
                Rails.logger.info "Loading #{type} ##{id} from the queue for " <<
                                  "Thermostat ##{thermostat.rhizome_eid} on #{thermostat.rhizome.name}"
              end
              compute_stop_time!
              trigger_children(:started)
            end
            transitions from: :queued, to: :started
          end

          event :send_message do
            after do
              Rails.logger.info 'Sent message!'
              trigger_children(:message_sent)
            end
            transitions from: :started, to: :message_sent
          end

          event :send_failure do
            after do
              Rails.logger.info 'Sent message failed!'
              trigger_children(:resending)
            end
            transitions from: :started, to: :resending
          end

          event :resend_success do
            after do
              Rails.logger.info 'Resend success!'
              trigger_children(:message_sent)
            end
            transitions from: :resending, to: :message_sent
          end

          event :resend_failure do
            after do
              Rails.logger.info 'Resend failure!'
              trigger_children(:failed)
            end
            transitions from: :resending, to: :failed
          end

          event :message_acknowledged do
            after do
              Rails.logger.info 'Message ack!'
              trigger_children(:done)
            end
            transitions from: :message_sent, to: :done
          end

          event :start_ramping do
            after do
              Rails.logger.info 'Start ramping!'
              trigger_children(:ramping)
            end
            transitions from: :message_sent, to: :ramping
          end

          event :message_rejected do
            after do
              Rails.logger.info 'Message rejected!'
              trigger_children(:failed)
            end
            transitions from: :message_sent, to: :failed
          end

          event :start_holding do
            after do
              Rails.logger.info 'Start holding!'
              trigger_children(:holding)
            end
            transitions from: :message_sent, to: :holding
          end

          event :ready do
            after do
              Rails.logger.info 'Ready!'
              trigger_children(:holding)
            end
            transitions from: :ramping, to: :holding
          end

          event :ramp_failure do
            after do
              Rails.logger.info 'Ramp fail!'
              trigger_children(:failed)
            end
            transitions from: :ramping, to: :failed
          end

          event :duration_reached do
            after do
              Rails.logger.info 'All done!'
              trigger_children(:done)
            end
            transitions from: :holding, to: :done
          end

          event :hold_failure do
            after do
              Rails.logger.info 'Hold failure!'
              trigger_children(:failed)
            end
            transitions from: :holding, to: :failed
          end

          event :failure do
            after do
              Rails.logger.info 'Shit!'
              trigger_children(:failed)
            end
            transitions to: :failed
          end

          event :override do
            after do
              Rails.logger.info 'New task was more important! Unblocking and overriding!'
              trigger_children(:overridden)
            end
            transitions to: :overridden
          end

          event :restart do
            after do
              Rails.logger.info 'Restarting!'
              trigger_children(:started)
            end
            transitions from: :failed, to: :started
          end

        end

      end

      # Computes the stop_time based on when the Task actually
      # gets started and the provided duration
      def compute_stop_time!
        itself.stop_time = Time.now.to_i + ramp_estimate + duration
        save!
        Rails.logger.info "Computed stop time as #{stop_time}"
      end

      # Start any child tasks based on the provided state
      # @param [Symbol] state The state trigger
      def trigger_children(state)

        children.each do |child|
          if child.send("on_#{state}?")
            Rails.logger.info "Queuing #{child.type} ##{child.id}"
            child.failure! unless TaskJob.set(queue: child.queue_name).perform_later(child)
          end
        end

      end

      def override_and_dequeue
        override! if Delayed::Job.find(job_id).destroy
      end

      # Determines if a task is done immediately after successfully sending a message
      # @return [TrueFalse] True if the task is done immediately, false otherwise
      def is_immediate?
        !(ramps? || holds?)
      end

      # Determines if a task is expected to need to ramp.
      # @return [TrueFalse] True if the task needs to ramp up or down, false otherwise
      def ramps?
        false
      end

      # Determines if a task is expected to hold for a period of time.
      # @return [TrueFalse] True if the task needs to hold, false otherwise
      def holds?
        false
      end

      # Performs the appropriate ramping action for the Task
      # @abstract This should be overridden by the subclass
      # @param last_check [EquipmentStatus] The last status associated with the Task
      def do_ramp(last_check)
        raise NoMethodError, 'This class does not implement #do_ramp'
      end

      # Performs the appropriate holding action for the Task
      # @abstract This should be overridden by the subclass
      # @param last_check [EquipmentStatus] The last status associated with the Task
      def do_hold(last_check)
        raise NoMethodError, 'This class does not implement #do_hold'
      end

    end
  end
end