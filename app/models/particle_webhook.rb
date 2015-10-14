class ParticleWebhook
  include ActiveModel::Model

  EVENT_TYPES = [:pumps, :temps]

  attr_accessor :device_id, :endpoint, :event_id, :webhook_id
  attr_reader :event_type

  validates :device_id, presence: true
  validates :endpoint, presence: true
  validates :event_type, presence: true
  validates :event_id, presence: true

  def event_type=(new_event_type)
    new_event_type = new_event_type.to_sym
    unless EVENT_TYPES.include?(new_event_type)
      raise ArgumentError, "Supplied Event Type (#{new_event_type}) is not a known type. Available options: #{EVENT_TYPES}"
    end
    @event_type = new_event_type
  end


  def to_task_hash
    {
        mydevices: true,
        deviceid: device_id,
        event: "#{event_type}/#{event_id}",
        url: "#{endpoint}/hooks/v1/#{event_type}",
        json: self.class.send("#{event_type}_task_json")
    }
  end

  class << self

    # Returns our current configuration for the JSON section of the Pump task webhook creation call.
    # Should probably be refactored into the database or something smart...
    def task_hash(args)
      {
          mydevices: true,
          deviceID: args[:device_id],
          event: "#{args[:event_type]}/#{args[:event_id]}",
          url: "#{args[:endpoint]}/hooks/v1/#{args[:event_type]}",
          json: self.class.send("#{args[:event_type]}_task")
      }
    end

    # Returns our current configuration for the JSON section of the Pump task webhook creation call.
    # Should probably be refactored into the database or something smart...
    def pump_task_json
      {
          id:       '{{id}}',
          state:    '{{state}}',
          stop_time: '{{stop_time}}',
          rhizome:  '{{SPARK_CORE_ID}}'
      }
    end

    # Returns our current configuration for the JSON section of the Temperature Sensor task webhook creation call.
    # Should probably be refactored into the database or something smart...
    def temp_task_json
      {
          id:             '{{id}}',
          state:          '{{state}}',
          stop_time:      '{{stop_time}}',
          temperature:    '{{temperature}}',
          last_read_time: '{{last_read_time}}',
          rhizome:        '{{SPARK_CORE_ID}}'
      }
    end

  end

end
