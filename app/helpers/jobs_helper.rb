module JobsHelper

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
