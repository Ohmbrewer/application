require 'test_helper'

class RhizomeTest < ActiveSupport::TestCase
  def setup
    @rhizome = rhizomes(:northern_brewer)
    @second_rhizome = rhizomes(:centennial)
  end

  test 'should be valid' do
    assert @rhizome.valid?
  end

  test 'name should be present' do
    @rhizome.name = ''
    assert_not @rhizome.valid?
  end

  test 'name should not be too long' do
    @rhizome.name = 'a' * 51
    assert_not @rhizome.valid?
  end

  test 'device id should not be too long' do
    @rhizome.particle_device.device_id = 'a' * 34
    assert_not @rhizome.valid?
  end

  test 'access token should not be too long' do
    @rhizome.particle_device.access_token = 'a' * 41
    assert_not @rhizome.valid?
  end

  test 'device id should not be too short' do
    @rhizome.particle_device.device_id = 'a' * 22
    assert_not @rhizome.valid?
  end

  test 'access token should not be too short' do
    @rhizome.particle_device.access_token = 'a' * 38
    assert_not @rhizome.valid?
  end

  test 'device ids should be unique' do
    @rhizome.particle_device.device_id = @second_rhizome.particle_device.device_id
    assert_not @rhizome.valid?
  end
end
