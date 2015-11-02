class RhizomePingJob < ActiveJob::Base
  queue_as :ping

  # Pings the given Rhizome
  # @param rhizome [Rhizome] A Rhizome to ping
  # @return [String] JSON response string
  def perform(rhizome)
    # Shout some rainbows!
    rhizome.particle.signal(true) if rhizome.connected?

    # Get the device info
    response = rhizome.particle.get_attributes

    # Knock it off with the rainbows!
    rhizome.particle.signal(false) if rhizome.connected?

    # Put the resulting attribute info out to the log and return it
    logger.info response
    response
  end

end