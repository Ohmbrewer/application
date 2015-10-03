class TemperatureSensorStatus < ActiveRecord::Base

  validates :device_id, presence: true,
            length: { minimum: 24, maximum: 24 }
  validates :temp_id, presence: true
  validates :state, presence: true

  # after_save   :notify_state_change
  # after_create :notify_state_change

  def initialize(attributes = nil, options = {})
    super self.class.parse_incoming_pump_status(attributes), options
  end

  # def to_sse_json
  #   JSON.generate({
  #                     device_id:      device_id,
  #                     temp_id:        temp_id,
  #                     state:          state,
  #                     stop_time:      stop_time,
  #                     temperature:    temperature,
  #                     last_read_time: last_read_time
  #                 })
  # end

  class << self

    # Parses the Temperature Sensor Status reported by our Particle webhook
    # @param [Hash] params A Hash or Hash-like object that contains parameters supplied by the Particle JSON webhook
    # @return [Hash] A parsed parameter Hash for producing a TemperatureSensorStatus
    def parse_incoming_temp_status(params)
      {
          device_id:      params['coreid'],
          temp_id:        params['data'].present? ? params['data']['id'] : nil,
          state:          params['data'].present? ? params['data']['state'] : nil,
          stop_time:      params['data'].present? ? Time.at(params['data']['stop_time'].to_i).to_datetime : nil,
          temperature:    params['data'].present? ? Time.at(params['data']['temperature'].to_i).to_datetime : nil,
          last_read_time: params['data'].present? ? Time.at(params['data']['last_read_time'].to_i).to_datetime : nil
      }
    end

  #   def on_change
  #     TemperatureSensorStatus.connection.execute 'LISTEN temp_statuses'
  #     loop do
  #       TemperatureSensorStatus.connection.raw_connection.wait_for_notify do |event, pid, temp_status|
  #         yield temp_status
  #       end
  #     end
  #   ensure
  #     TemperatureSensorStatus.connection.execute 'UNLISTEN temp_statuses'
  #   end
  #
  #   def event_channel
  #     {event: 'temp_status_update'}
  #   end
  #
  end
  #
  # private
  #
  #   def notify_state_change
  #     TemperatureSensorStatus.connection.execute "NOTIFY temp_statuses, '#{to_sse_json}'"
  #   end

end
