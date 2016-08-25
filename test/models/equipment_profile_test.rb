require 'test_helper'

class EquipmentProfileTest < ActiveSupport::TestCase
  def setup
    @equipment_profile = equipment_profiles(:one)
  end

  test 'should recognize various collections' do
    assert_equal @equipment_profile.attached,
                 [
                   @equipment_profile.equipments,
                   @equipment_profile.thermostats,
                   @equipment_profile.recirculating_infusion_mash_systems
                 ].flatten
  end
end
