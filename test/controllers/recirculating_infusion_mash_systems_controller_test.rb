require 'test_helper'

class RecirculatingInfusionMashSystemsControllerTest < ActionController::TestCase
  setup do
    @user = users(:users_001)
    log_in_as(@user)
    @equipment_profile = equipment_profiles(:equipment_profiles_001)
    @equipment_profile_create = equipment_profiles(:equipment_profiles_003)
    @rims = recirculating_infusion_mash_systems(:recirculating_infusion_mash_systems_001)

  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @rims
    assert_response :success
  end

  test "should get new" do
    get :new, equipment_profile: @equipment_profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rims
    assert_response :success
  end

  test "should get create" do
    assert_difference('RecirculatingInfusionMashSystem.count') do
    patch :create, recirculating_infusion_mash_system: {
                   equipment_profile: @equipment_profile_create,
                   tube_attributes: {
                       element_attributes: {
                           control_pin: "0", power_pin: "1"
                       },
                       sensor_attributes: {
                           data_pin: "2", onewire_id: "a"
                       }
                   },
                   safety_sensor_attributes:{
                       data_pin: "3", onewire_id: "b"
                   }, recirculation_pump_attributes: {

                       power_pin: "5"

                   } }
    end
    assert_redirected_to equipment_profiles_path
  end

  test "should get update" do
    patch :update, id: @rims, recirculating_infusion_mash_system: {
                     equipment_profile: @equipment_profile_create,
                     tube_attributes: {
                         element_attributes: {
                             control_pin: "2", power_pin: "3"
                         },
                         sensor_attributes: {
                             data_pin: "4", onewire_id: "a"
                         }
                     },
                     safety_sensor_attributes:{
                         data_pin: "5", onewire_id: "b"
                     }, recirculation_pump_attributes: {

                         power_pin: "1"

                     } }
    assert_response :success
    assert @rims.tube.element.power_pin = "3"
    #assert_redirected_to @rims
  end

  test "should get destroy" do
    assert_difference('RecirculatingInfusionMashSystem.count', -1) do
    get :destroy, id: @rims
    end
    assert_redirected_to equipment_profiles_path
  end
end
