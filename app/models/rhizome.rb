class Rhizome < ActiveRecord::Base

  # == Each Rhizome has a one-to-one relationship with a Particle. ==
  # This sets up that relationship and makes it so we can pass Particle attribute changes through the
  # Rhizome's controller rather than building a full, separate controller just for the associated Particle.
  has_one :particle, inverse_of: :rhizome,
                     dependent: :destroy

  accepts_nested_attributes_for :particle

  validates :name, presence: true,
                   length: { maximum: 50 }

end
