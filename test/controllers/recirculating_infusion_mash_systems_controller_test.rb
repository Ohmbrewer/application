require 'test_helper'

class RecirculatingInfusionMashSystemsControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @equipment_profile = equipment_profiles(:one)
    @rims = recirculating_infusion_mash_systems(:rims_1)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get show' do
    get :show, id: @rims
    assert_response :success
  end

  test 'should get new' do
    get :new, rhizome: @rhizome
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @rims
    assert_response :success
  end

  test 'should get create' do
    assert_difference('RecirculatingInfusionMashSystem.count') do
      patch :create,
            recirculating_infusion_mash_system: {
              equipment_profile: @equipment_profile,
              tube_attributes: {
                element_attributes: {
                  control_pin: '3',
                  power_pin: '1'
                },
                sensor_attributes: {
                  data_pin: '0',
                  onewire_index: '0'
                }
              },
              safety_sensor_attributes: {
                data_pin: '0',
                onewire_index: '1'
              },
              recirculation_pump_attributes: {
                control_pin: '5'
              }
            }
    end
    assert_redirected_to equipment_profiles_path
  end

  test 'should get update' do
    patch :update,
          id: @rims,
          recirculating_infusion_mash_system: {
            rhizome: @rhizome_create,
            tube_attributes: {
              element_attributes: {
                control_pin: '2',
                power_pin: '3'
              },
              sensor_attributes: {
                data_pin: '4',
                onewire_index: '0'
              }
            },
            safety_sensor_attributes: {
              data_pin: '5',
              onewire_index: '1'
            },
            recirculation_pump_attributes: {
              control_pin: '1'
            }
          }
    assert_redirected_to equipment_profiles_path
  end

  test 'should get destroy' do
    assert_difference('RecirculatingInfusionMashSystem.count', -1) do
      get :destroy, id: @rims
    end
    assert_redirected_to equipment_profiles_path
  end
end
