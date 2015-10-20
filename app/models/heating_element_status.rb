class HeatingElementStatus < ActiveRecord::Base

    validates :device_id, presence: true,
              length: { minimum: 24, maximum: 24 }
    validates :heat_id, presence: true
    validates :state, presence: true

    # after_save   :notify_state_change
    # after_create :notify_state_change

    def initialize(attributes = nil, options = {})
      super self.class.parse_incoming_heating_element_status(attributes), options
    end

    # def to_sse_json
    #   JSON.generate({
    #                     device_id:  device_id,
    #                     heat_id:    heat_id,
    #                     state:      state,
    #                     stop_time:  stop_time
    #                 })
    # end

    class << self

      # Parses the Heating Element Status reported by our Particle webhook
      # @param [Hash] params A Hash or Hash-like object that contains parameters supplied by the Particle JSON webhook
      # @return [Hash] A parsed parameter Hash for producing a HeatingElementStatus
      def parse_incoming_heating_element_status(params)
        {
            device_id: params['coreid'],
            heat_id:   params['data'].present? ? params['data']['id'] : nil,
            state:     params['data'].present? ? params['data']['state'] : nil,
            stop_time:  params['data'].present? ? Time.at(params['data']['stop_time'].to_i).to_datetime : nil
        }
      end

      #   def on_change
      #     HeatingElementStatus.connection.execute 'LISTEN heating_element_statuses'
      #     loop do
      #       HeatingElementStatus.connection.raw_connection.wait_for_notify do |event, pid, pump_status|
      #         yield pump_status
      #       end
      #     end
      #   ensure
      #     HeatingElementStatus.connection.execute 'UNLISTEN heating_element_statuses'
      #   end
      #
      #   def event_channel
      #     {event: 'heating_element_status_update'}
      #   end
      #
    end
    #
    # private
    #
    #   def notify_state_change
    #     HeatingElementStatus.connection.execute "NOTIFY heating_element_statuses, '#{to_sse_json}'"
    #   end

end
