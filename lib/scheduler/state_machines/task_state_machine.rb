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
              message = ''
              unless equipment.nil?
                message = "Loading #{type} ##{id} from the queue for " \
                          "#{equipment.type} ##{equipment.rhizome_eid} on #{equipment.rhizome.name}"
              end
              unless thermostat.nil?
                message = "Loading #{type} ##{id} from the queue for " \
                          "Thermostat ##{thermostat.rhizome_eid} on #{thermostat.rhizome.name}"
              end
              itself.start_time = Time.now.to_i
              compute_stop_time!

              message_and_trigger_children message, :started
            end
            transitions from: :queued, to: :started
          end

          event :send_message do
            after do
              message_and_trigger_children 'Sent message!', :message_sent
            end
            transitions from: :started, to: :message_sent
          end

          event :send_failure do
            after do
              message_and_trigger_children 'Sent message failed!', :resending
            end
            transitions from: :started, to: :resending
          end

          event :resend_success do
            after do
              message_and_trigger_children 'Resend success!', :message_sent
            end
            transitions from: :resending, to: :message_sent
          end

          event :resend_failure do
            after do
              message_and_trigger_children 'Resend failure!', :failed
            end
            transitions from: :resending, to: :failed
          end

          event :message_acknowledged do
            after do
              message_and_trigger_children 'Message ack!', :done
            end
            transitions from: :message_sent, to: :done
          end

          event :start_ramping do
            after do
              itself.ramp_start_time = Time.now.to_i
              save!
              message_and_trigger_children 'Start ramping!', :ramping
            end
            transitions from: :message_sent, to: :ramping
          end

          event :message_rejected do
            after do
              itself.end_time = Time.now.to_i
              save!
              message_and_trigger_children 'Message rejected!', :failed
            end
            transitions from: :message_sent, to: :failed
          end

          event :start_holding do
            after do
              itself.hold_start_time = Time.now.to_i
              save!
              message_and_trigger_children 'Start holding!', :holding
            end
            transitions from: :message_sent, to: :holding
          end

          event :ready do
            after do
              itself.ramp_end_time = Time.now.to_i
              itself.hold_start_time = Time.now.to_i
              save!
              message_and_trigger_children 'Ready!', :holding
            end
            transitions from: :ramping, to: :holding
          end

          event :ramp_failure do
            after do
              itself.end_time = Time.now.to_i
              save!
              message_and_trigger_children 'Ramp fail!', :failed
            end
            transitions from: :ramping, to: :failed
          end

          event :duration_reached do
            after do
              itself.end_time = Time.now.to_i
              save!
              message_and_trigger_children 'All done!', :done
            end
            transitions from: :holding, to: :done
          end

          event :hold_failure do
            after do
              itself.end_time = Time.now.to_i
              save!
              message_and_trigger_children 'Hold failure!', :failed
            end
            transitions from: :holding, to: :failed
          end

          event :failure do
            after do
              itself.end_time = Time.now.to_i
              save!
              message_and_trigger_children 'Shit!', :failed
            end
            transitions to: :failed
          end

          event :override do
            after do
              message_and_trigger_children 'New task was more important! Unblocking and overriding!', :overridden
            end
            transitions to: :overridden
          end

          event :restart do
            after do
              message_and_trigger_children 'Restarting!', :started
            end
            transitions from: :failed, to: :started
          end
        end
      end

      # Computes the stop_time based on when the Task actually
      # gets started and the provided duration
      def compute_stop_time!
        itself.stop_time = Time.now.to_i + itself.ramp_estimate + itself.duration
        save!
        Rails.logger.info "Computed stop time as #{itself.stop_time}"
      end

      # Logs a message and passes on the supplied trigger to any child Tasks
      # @param [String] message The message to log
      # @param [Symbol] trigger The trigger to pass along
      def message_and_trigger_children(message, trigger)
        Rails.logger.info message
        trigger_children trigger
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
      def immediate?
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
