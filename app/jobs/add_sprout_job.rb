require 'rhizome_interfaces/errors/rhizome_unresponsive_error'
require 'rhizome_interfaces/errors/rhizome_argument_error'
class AddSproutJob < ActiveJob::Base
  # Note that this is the default task queue.
  # You should probably set a more specific
  # (yet similar) one so it doesn't block other
  # jobs unnecessarily.
  queue_as :add_sprout

  rescue_from(RhizomeInterfaces::Errors::RhizomeUnresponsiveError) do |exception|
    Rails.logger.error '======================================='
    Rails.logger.error "Failed to add Sprout to \"#{arguments.first.rhizome.name}\"! Error:"
    Rails.logger.error exception.message
    Rails.logger.error '======================================='
    raise RhizomeInterfaces::Errors::RhizomeUnresponsiveError
  end

  # Adds the specified Equipment to the Rhizome
  # @param [Equipment|Thermostat|RecirculatingInfusionMashSystem] sprout The Sprout to add
  def perform(sprout)
    # Refresh the Equipment to make sure it's most up-to-date
    sprout.reload

    begin
      # Send the command to /add that instantiates the Sprout
      tries = 1
      until sprout.send_add
        # Only try so many times...
        raise RhizomeInterfaces::Errors::RhizomeUnresponsiveError if tries >= 3
        tries += 1

        # If the command wasn't successful, perhaps there was a network problem.
        # Try again a little later...
        sleep 10
      end
    rescue RhizomeInterfaces::Errors::RhizomeArgumentError => e
      Rails.logger.error '======================================='
      Rails.logger.error 'Failed to add Sprout due to a bad argument. ' <<
                         'Make sure the Sprout is not already on the Rhizome and try again. ' <<
                         'If the problem persists, you may need to revise your pin settings.'
      Rails.logger.error 'Details:'
      Rails.logger.error e.message
      Rails.logger.error '======================================='
      return false
    end

    true
  end

  # If the job itself fails, let's wait 5 seconds and try again
  # @param [Time] current_time Current time
  # @param [Integer] attempts Number of attempts before giving up (ignored)
  # @return [Time] The time to reschedule the job
  def reschedule_at(current_time, attempts)
    current_time + 5.seconds
  end

end
