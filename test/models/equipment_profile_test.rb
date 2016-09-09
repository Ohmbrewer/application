require 'test_helper'

class EquipmentProfileTest < ActiveSupport::TestCase
  def setup
    @equipment_profile = equipment_profiles(:equipment_profile_one)

    # @equipment_profile.recirculating_infusion_mash_systems.each do |rims|
    #   @equipment_profile.add_rims_children(rims)
    # end
    #
    # @equipment_profile.thermostats.each do |therm|
    #   @equipment_profile.add_thermostat_children(therm)
    # end
    #
    @equipment_profile.equipments << equipments(:single_pump)
  end

  test 'should recognize various collections' do
    assert_equal @equipment_profile.attached,
                 [
                   @equipment_profile.equipments,
                   @equipment_profile.thermostats,
                   @equipment_profile.recirculating_infusion_mash_systems
                 ].flatten
  end

  # FIXME: This isn't quite working yet.
  # test 'should duplicate' do
  #   duplicate_equipment_profile = @equipment_profile.deep_dup
  #   duplicate_equipment_profile.save
  #   duplicate_equipment_profile.reload
  #
  #   assert_equal duplicate_equipment_profile.name, "#{@equipment_profile.name} (Copy)"
  #   # puts @equipment_profile.equipments.collect { |e| e.pins }
  #   puts @equipment_profile.thermostats.collect { |t| [t.sensor.pins, t.element.pins] }
  #   # puts @equipment_profile.recirculating_infusion_mash_systems.collect { |r| [[r.tube.sensor.pins, r.tube.element.pins], r.safety_sensor.pins, r.recirculation_pump.pins] }
  #   puts @equipment_profile.sprouts.length
  #   puts '----'
  #   # puts duplicate_equipment_profile.equipments.collect { |e| e.pins }
  #   puts duplicate_equipment_profile.thermostats.collect { |t| [t.sensor.pins, t.element.pins] }
  #   # puts duplicate_equipment_profile.recirculating_infusion_mash_systems.collect { |r| [[r.tube.sensor.pins, r.tube.element.pins], r.safety_sensor.pins, r.recirculation_pump.pins] }
  #   puts duplicate_equipment_profile.sprouts.length
  #
  #   @equipment_profile.equipments.each_with_index do |equipment, i|
  #     assert_equal duplicate_equipment_profile.equipments[i].pins, equipment.pins
  #   end
  #
  #   @equipment_profile.thermostats.each_with_index do |thermostat, i|
  #     assert_equal duplicate_equipment_profile.thermostats[i].sensor.pins, thermostat.sensor.pins
  #     assert_equal duplicate_equipment_profile.thermostats[i].element.pins, thermostat.element.pins
  #   end
  #
  #   @equipment_profile.recirculating_infusion_mash_systems.each_with_index do |rims, i|
  #     assert_equal duplicate_equipment_profile.recirculating_infusion_mash_systems[i].tube.sensor.pins, rims.tube.sensor.pins
  #     assert_equal duplicate_equipment_profile.recirculating_infusion_mash_systems[i].tube.element.pins, rims.tube.element.pins
  #
  #     assert_equal duplicate_equipment_profile.recirculating_infusion_mash_systems[i].safety_sensor.pins, rims.safety_sensor.pins
  #     assert_equal duplicate_equipment_profile.recirculating_infusion_mash_systems[i].recirculation_pump.pins, rims.recirculation_pump.pins
  #   end
  # end
end
