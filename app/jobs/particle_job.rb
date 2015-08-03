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

  class << self

    # Consistently formats a Hash of arguments for passing to a Particle device function
    # @param [Hash] args_hash Hash of the arguments to pass the Particle device's function
    # @param [Array] order_by Optional order of the arguments
    # @return [String] String representation of the arguments to pass to the Particle device's function
    def to_particle_args(args_hash, order_by = nil)
      if order_by.nil?
        args_hash.map{|_,v| v }.join(',')
      else
        result = ''
        order_by.each { |k| result << "#{args_hash[k]}," }
        result.chop
      end
    end

  end

  private

  def particle_params(*args)
    args.to_h.
         symbolize_keys.
         slice(:device_id, :access_token, :particle, :id)
  end

end