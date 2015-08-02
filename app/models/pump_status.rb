class PumpStatus < ActiveRecord::Base

  validates :device_id, presence: true,
            length: { minimum: 24, maximum: 24 }
  validates :pump_id, presence: true
  validates :state, presence: true

  def initialize(attributes = nil, options = {})
    super self.class.parse_incoming_pump_status(attributes), options
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

  end


  private

end
