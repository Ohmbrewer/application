require 'eventstreamer/sse'

class StatusUpdatesController < ApplicationController
  include ActionController::Live

  # == Enabled Before Filters ==
  before_action :logged_in_user,
                only: [:pumps, :temps, :heats]

  # == Routes ==

  def pumps
    produce_stream_for PumpStatus
  end

  def temps
    produce_stream_for TemperatureSensorStatus
  end

  def heats
    produce_stream_for HeatingElementStatus
  end

  private

    def produce_stream_for(status_type)
      # SSE expects the `text/event-stream` content type
      response.headers['Cache-Control'] = 'no-cache'
      response.headers['Content-Type'] = 'text/event-stream'

      sse = EventStreamer::SSE.new(response.stream)

      begin
        status_type.on_change do |data|
          sse.write(data, status_type.event_channel)
        end
      rescue IOError
        # When the client disconnects, we'll get an IOError on write
      ensure
        sse.close
      end

      render nothing: true
    end
end
