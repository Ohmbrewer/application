class PumpStatus < ActiveRecord::Base

  validates :device_id, presence: true,
            length: { minimum: 24, maximum: 24 }
  validates :pump_id, presence: true
  validates :state, presence: true

  after_save   :notify_state_change
  after_create :notify_state_change

  def initialize(attributes = nil, options = {})
    super self.class.parse_incoming_pump_status(attributes), options
  end

  def to_sse_json
    JSON.generate({
                      device_id:  device_id,
                      pump_id:    pump_id,
                      state:      state,
                      speed:      speed,
                      stop_time:  stop_time
                  })
  end

  class << self

    # Parses the Pump Status reported by our Particle webhook
    # @param [Hash] params A Hash or Hash-like object that contains parameters supplied by the Particle JSON webhook
    # @return [Hash] A parsed parameter Hash for producing a PumpStatus
    def parse_incoming_pump_status(params)
      {
          device_id: params['coreid'],
          pump_id:   params['data'].present? ? params['data']['id'] : nil,
          state:     params['data'].present? ? params['data']['state'] : nil,
          stop_time:  params['data'].present? ? Time.at(params['data']['stopTime'].to_i).to_datetime : nil,
          speed:     params['data'].present? ? params['data']['speed'] : nil
      }
    end

    def on_change
      PumpStatus.connection.execute 'LISTEN pump_statuses'
      loop do
        PumpStatus.connection.raw_connection.wait_for_notify do |event, pid, pump_status|
          yield pump_status
        end
      end
    ensure
      PumpStatus.connection.execute 'UNLISTEN pump_statuses'
    end

    def event_channel
      {event: 'pump_status_update'}
    end

  end

  private

    def notify_state_change
      PumpStatus.connection.execute "NOTIFY pump_statuses, '#{to_sse_json}'"
    end

end
