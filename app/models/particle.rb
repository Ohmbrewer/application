class Particle < ActiveRecord::Base

  attr_encrypted :access_token, key: Rails.application.config.keys[:particle][:access_token]

  # Provide an alias for easier compatibility with the ruby_spark gem
  alias_attribute :core_id, :device_id

  # Although undocumented, these seem to be the requirements for the Particle access variables
  validates :device_id, length: { minimum: 24, maximum: 24 }
  validates :access_token, length: { minimum: 40, maximum: 40 }

end
