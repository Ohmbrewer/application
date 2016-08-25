require 'rhizome_interfaces/webhooks/json_templates'
class ParticleWebhook
  include ActiveModel::Model
  include RhizomeInterfaces::Webhooks::JSONTemplates

  EVENT_TYPES = [:pump, :temp, :heat].freeze

  attr_accessor :rhizome, :endpoint, :event_id, :webhook_id
  attr_reader :event_type

  validates :rhizome, presence: true
  validates :endpoint, presence: true
  validates :event_type, presence: true
  validates :event_id, presence: true

  def event_type=(new_event_type)
    new_event_type = new_event_type.to_sym
    unless EVENT_TYPES.include?(new_event_type)
      raise ArgumentError,
            "Supplied Event Type (#{new_event_type}) is not a known type. Available options: #{EVENT_TYPES}"
    end
    @event_type = new_event_type
  end

  # Provides an interface to the Particlerb library
  def to_task_hash
    {
      mydevices: true,
      deviceid: rhizome.particle_device.device_id,
      event: "#{event_type}/#{event_id}",
      url: "#{endpoint}/hooks/v1/#{event_type}",
      json: self.class.send("#{self.class.event_to_json(event_type)}_task_json")
    }
  end
end
