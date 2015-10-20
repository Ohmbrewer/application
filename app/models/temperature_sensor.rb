require 'rhizome_sprout/rhizome_sprout'

class TemperatureSensor < Equipment
  include RhizomeSprout

  belongs_to :thermostat, validate: true, touch: true
  belongs_to :recirculating_infusion_mash_system, validate: true,
                                                  touch: true,
                                                  foreign_key: :rims_id
  alias_method :rims, :recirculating_infusion_mash_system

  store_accessor :pins, :data_pin, :onewire_id

  validates :onewire_id, presence: true, on: :update
  validates :data_pin, presence: true, on: :update

  # == Sproutable Interface Methods ==
  def rhizome_eid
    onewire_id
  end

  def rhizome_type_name
    'temp'
  end

  def destroy_disabled?
    !thermostat.nil? ||
    !recirculating_infusion_mash_system.nil? ||
    (!thermostat.nil? && !thermostat.recirculating_infusion_mash_system.nil?)
  end

end
