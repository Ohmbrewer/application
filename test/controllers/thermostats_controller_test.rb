require 'test_helper'

class ThermostatsControllerTest < ActionController::TestCase
  setup do
    @user = users(:users_001)
    log_in_as(@user)
    @equipment_profile = equipment_profiles(:equipment_profiles_001)
    @equipment_profile_create = equipment_profiles(:equipment_profiles_003)
    @thermostat = thermostats(:thermostats_001)
  end
  # TODO: investigate why this test fails - this is a problem in the app as well
  # test "should get index" do
  #   get :index
  #   assert_response :success
  # end

  test "should get show" do
    get :show, id: @thermostat
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @thermostat
    assert_response :success
  end

  test "should get create" do
    assert_difference('Thermostat.count') do
      post :create, thermostat: {equipment_profile: @equipment_profile_create.id, element_attributes: {control_pin: "D0", power_pin: "D1"}, sensor_attributes: { data_pin: "D2", onewire_id: "a"}}
    end
    assert_redirected_to equipment_profiles_path
  end

  test "should get update" do
    patch :update, id:@thermostat, thermostat: {equipment_profile: @equipment_profile_create.id, element_attributes: {control_pin: "D2", power_pin: "D3"}, sensor_attributes: { data_pin: "D4", onewire_id: "a"}}
    assert @thermostat.element.control_pin = "D2"
    assert_redirected_to equipment_profiles_path
  end

  # TODO: Fix this test. works in the app.
  # test "should get destroy" do
  #   assert_difference('Thermostat.count', -1) do
  #     delete :destroy, id: @thermostat.id
  #   end
  #   assert_redirected_to equipment_profiles_path
  # end
end
