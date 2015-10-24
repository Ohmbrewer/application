require 'aasm'
module Scheduler
  module StateMachines
    module TaskStateMachine

      # We're providing self.included to insert the AASM definitions
      # into the including class's Class Methods.
      def self.included(base)
        base.send(:include, AASM)

        base.send(:aasm, column: :status, whiny_transitions: false) do

          # These states must match the statuses of Task::status
          state :scheduled, initial: true
          state :message_sent
          state :ramping
          state :holding
          state :done
          state :failed
          state :resending

          event :send_message do
            after do
              puts 'Sent message!'
            end
            transitions from: :scheduled, to: :message_sent
          end

          event :send_failure do
            after do
              puts 'Sent message failed!'
            end
            transitions from: :scheduled, to: :resending
          end

          event :resend_success do
            after do
              puts 'Resend success!'
            end
            transitions from: :resending, to: :message_sent
          end

          event :resend_failure do
            after do
              puts 'Resend failure!'
            end
            transitions from: :resending, to: :failed
          end

          event :message_acknowledged do
            after do
              puts 'Message ack!'
            end
            transitions from: :message_sent, to: :done
          end

          event :start_ramping do
            after do
              puts 'Start ramping!'
            end
            transitions from: :message_sent, to: :ramping
          end

          event :message_rejected do
            after do
              puts 'Message rejected!'
            end
            transitions from: :message_sent, to: :failed
          end

          event :start_holding do
            after do
              puts 'Start holding!'
            end
            transitions from: :message_sent, to: :holding
          end

          event :ready do
            after do
              puts 'Ready!'
            end
            transitions from: :ramping, to: :holding
          end

          event :ramp_failure do
            after do
              puts 'Ramp fail!'
            end
            transitions from: :ramping, to: :failed
          end

          event :duration_reached do
            after do
              puts 'All done!'
            end
            transitions from: :holding, to: :done
          end

          event :hold_failure do
            after do
              puts 'Hold failure!'
            end
            transitions from: :holding, to: :failed
          end

          event :failure do
            after do
              puts 'Shit!'
            end
            transitions to: :failed
          end

          event :restart do
            after do
              puts 'Restarting!'
            end
            transitions from: :failed, to: :scheduled
          end

        end

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