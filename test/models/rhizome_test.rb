require 'test_helper'

# FIXME: For some reason, attr_encrypted isn't playing nicely with minitest. These tests won't pass yet.
class RhizomeTest < ActiveSupport::TestCase
  def setup
    @rhizome = rhizomes(:zeus)
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
    @rhizome.device_id = 'a' * 24
    assert_not @rhizome.valid?
  end

  test 'access token should not be too long' do
    @rhizome.access_token = 'a' * 40
    assert_not @rhizome.valid?
  end

  test 'device id should not be too short' do
    @rhizome.device_id = 'a' * 22
    assert_not @rhizome.valid?
  end

  test 'access token should not be too short' do
    @rhizome.access_token = 'a' * 38
    assert_not @rhizome.valid?
  end

  test 'device ids should be unique' do
    duplicate_rhizome = @rhizome.dup
    @rhizome.save
    assert_not duplicate_rhizome.valid?
  end

end
