class ParticleJob < ActiveJob::Base

  attr_accessor :particle

  def initialize(*arguments)
    super
    params = particle_params(*arguments)
    # @particle = RubySpark::Core.new(params[:core_id], params[:access_token])
    case
      when !params[:core_id].nil? && !params[:access_token].nil?
        @particle = RubySpark::Core.new(params[:core_id],
                                        params[:access_token])
      when !params[:id].nil?
        @particle = Particle.find_by(params[:id]).connection
      else
        @particle = params[:particle].connection
    end
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
         slice(:core_id, :access_token, :particle, :id)
  end

end