class ParticleJob < ActiveJob::Base

  attr_accessor :particle

  def initialize(*arguments)
    super
    params = particle_params(*arguments)
    
    case
      when !params[:device_id].nil? && !params[:access_token].nil?
        @particle = Particle::Client.new(access_token: params[:access_token])
                                    .device(params[:device_id])
      when !params[:id].nil?
        @particle = ParticleDevice.find_by(id: params[:id]).connection
      else
        @particle = params[:particle].connection
    end
  end

  private

  def particle_params(*args)
    args.to_h.
         symbolize_keys.
         slice(:device_id, :access_token, :particle, :id)
  end

end