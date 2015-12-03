require 'aasm'
module Scheduler
  module StateMachines
    module BatchStateMachine

      # We're providing self.included to insert the AASM definitions
      # into the including class's Class Methods.
      def self.included(base)
        base.send(:include, AASM)

        base.send(:aasm, column: :status, whiny_transitions: false) do

          # These states must match the statuses of Batch::status
          state :not_ready, initial: true
          state :ready
          state :running
          state :done
          state :stopped
          state :error

          event :make_ready do
            transitions from: :not_ready, to: :ready
          end

          event :start do
            transitions from: :ready, to: :running do
              guard do
                !rhizomes_in_use?
              end
            end
          end

          event :stop do
            transitions from: :running, to: :stopped
          end

          event :finish do
            transitions from: :running, to: :done
          end

          event :failure do
            transitions to: :error
          end

        end

        # Determines if the Rhizomes that will fill the Equipment Profile
        # roles for the Batch are currently in use by another Batch.
        # @abstract Batch should override this with a better implementation
        # @return [TrueFalse] Whether the Batch's Rhizomes are in use
        def rhizomes_in_use?
          false
        end
      end

    end
  end
end
