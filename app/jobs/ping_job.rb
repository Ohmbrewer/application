class PingJob < ParticleJob
  queue_as :ping

  def perform(*args)
    # Shout some rainbows!
    @particle.signal(true) if @particle.connected?

    # Get the device info
    response = @particle.get_attributes

    # Knock it off with the rainbows!
    @particle.signal(false) if @particle.connected?

    # Put the resulting attribute info out to the log and return it
    logger.info response
    response
  end

end