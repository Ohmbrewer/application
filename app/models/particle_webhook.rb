class ParticleWebhook
  include ActiveModel::Model

  EVENT_TYPES = [:pumps]

  attr_accessor :device_id, :endpoint, :event_id
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
    settings = {
        mydevices: true,
        deviceid: device_id,
        event: "#{event_type}/#{event_id}",
        url: "#{endpoint}/hooks/v1/#{event_type}"
    }

    case event_type
      when :pumps
        settings.merge!({json: self.class.pump_task_json})
      else
        raise ArgumentError, "Invalid Event Type supplied: #{event_type}"
    end

    settings
  end

  class << self

    # Returns our current configuration for the JSON section of the Pump task webhook creation call.
    # Should probably be refactored into the database or something smart...
    def task_hash(args)
      settings = {
          mydevices: true,
          deviceid: args[:device_id],
          event: "#{args[:event_type]}/#{args[:event_id]}",
          url: "#{args[:endpoint]}/hooks/v1/#{args[:event_type]}"
      }

      case args[:event_type]
        when :pumps
          settings.merge!({json: pump_task_json})
        else
          raise ArgumentError, "Invalid Event Type supplied: #{args[:event_type]}"
      end

      settings
    end

    # Returns our current configuration for the JSON section of the Pump task webhook creation call.
    # Should probably be refactored into the database or something smart...
    def pump_task_json
      {
          id:       '{{id}}',
          state:    '{{state}}',
          speed:    '{{speed}}',
          stopTime: '{{stopTime}}',
          rhizome:  '{{SPARK_CORE_ID}}'
      }
    end

  end

end