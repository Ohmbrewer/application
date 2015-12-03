class ParticleDevice < ActiveRecord::Base

  belongs_to :rhizome, inverse_of: :particle_device

  attr_encrypted :access_token, key: Rails.application.config.keys[:particle][:access_token]

  # Provide an alias for easier compatibility with the ruby_spark gem
  alias_attribute :core_id, :device_id

  # Although undocumented, these seem to be the requirements for the Particle access variables
  validates :device_id, presence: true,
                        length: { minimum: 24, maximum: 24 },
                        uniqueness: true
  validates :access_token, length: { minimum: 40, maximum: 40 }

  # Provides the interface for connecting to the ParticleDevice
  def connection
    Particle::Client.new(access_token: self.access_token)
                    .device(self.device_id)
  end

end
