require 'json'

module EventStreamer
  # A class of Objects that knows how to format messages as Server-Sent Events
  # and emits those messages to the live stream
  # @see http://tenderlovemaking.com/2012/07/30/is-it-live.html
  class SSE

    # @param [Stream] io A streamable object
    def initialize(io)
      @io = io
    end

    # @param [Object] object An object that should be able to be formatted for SSE's
    # @param [Object] options Additional options that can be written with the SSE
    def write(object, options = {})
      options.each do |k,v|
        @io.write "#{k}: #{v}\n"
      end
      @io.write "data: #{JSON.dump(object)}\n\n"
    end

    # Closes the IO stream
    def close
      @io.close
    end
  end
end