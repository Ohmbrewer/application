class PingJob < ParticleJob
  queue_as :ping

  def perform(*args)
    response = particle.info
    logger.info response
    response
  end

end