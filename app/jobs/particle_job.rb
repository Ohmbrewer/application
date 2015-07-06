class ParticleJob < ActiveJob::Base

  attr_accessor :particle

  def initialize(*arguments)
    super
    params = particle_params(*arguments)
    @particle = RubySpark::Core.new(params[:core_id], params[:access_token])
  end

  def info
    @particle.info
  end

  def function
    @particle.function(:name, :argument)
  rescue => e
    e.to_s
  end

  def variable
    @particle.variable(:name)
  rescue => e
    e.to_s
  end

  private

  def particle_params(*args)
    args.to_h.
         symbolize_keys.
         slice(:core_id, :access_token)
  end

end