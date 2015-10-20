# require 'eventstreamer/sse'
#
# class StatusUpdatesController < ApplicationController
#
#   include ActionController::Live
#
#   # == Enabled Before Filters ==
#
#   before_action :logged_in_user,
#                 only: [:pumps]
#
#   # == Routes ==
#
#   def pumps
#     # SSE expects the `text/event-stream` content type
#     response.headers['Cache-Control'] = 'no-cache'
#     response.headers['Content-Type'] = 'text/event-stream'
#
#     sse = EventStreamer::SSE.new(response.stream)
#
#     begin
#       PumpStatus.on_change do |data|
#         sse.write(data, PumpStatus.event_channel)
#       end
#     rescue IOError
#       # When the client disconnects, we'll get an IOError on write
#     ensure
#       sse.close
#     end
#
#     render nothing: true
#   end
#
#   def temps
#     # SSE expects the `text/event-stream` content type
#     response.headers['Cache-Control'] = 'no-cache'
#     response.headers['Content-Type'] = 'text/event-stream'
#
#     sse = EventStreamer::SSE.new(response.stream)
#
#     begin
#       TemperatureSensorStatus.on_change do |data|
#         sse.write(data, TemperatureSensorStatus.event_channel)
#       end
#     rescue IOError
#       # When the client disconnects, we'll get an IOError on write
#     ensure
#       sse.close
#     end
#
#     render nothing: true
#   end
#
#   def heat
#     # SSE expects the `text/event-stream` content type
#     response.headers['Cache-Control'] = 'no-cache'
#     response.headers['Content-Type'] = 'text/event-stream'
#
#     sse = EventStreamer::SSE.new(response.stream)
#
#     begin
#       HeatingElementStatus.on_change do |data|
#         sse.write(data, HeatingElementStatus.event_channel)
#       end
#     rescue IOError
#       # When the client disconnects, we'll get an IOError on write
#     ensure
#       sse.close
#     end
#
#     render nothing: true
#   end
#
# end
