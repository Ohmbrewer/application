require 'test_helper'

class ThermostatsControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @equipment_profile = equipment_profiles(:one)
    @thermostat = thermostats(:without_rims)
  end

  test 'should get thermostats index' do
    get :index
    assert_response :success
  end

  test 'should get show thermostat' do
    get :show, id: @thermostat
    assert_response :success
  end

  test 'should get new thermostat' do
    get :new
    assert_response :success
  end

  test 'should get edit thermostat' do
    get :edit, id: @thermostat
    assert_response :success
  end

  test 'should get create thermostat' do
    assert_difference('Thermostat.count') do
      post :create,
           thermostat: {
             equipment_profile: @equipment_profile.id,
             element_attributes: {
               control_pin: 'D1',
               power_pin: 'D2'
             },
             sensor_attributes: {
               data_pin: 'D3',
               onewire_index: '0'
             }
           }
    end
    assert_redirected_to equipment_profiles_path
  end

  test 'should not create thermostat' do
    assert_no_difference('Thermostat.count') do
      post :create,
           thermostat: {
             equipment_profile: @equipment_profile.id,
             element_attributes: {
               control_pin: '',
               power_pin: ''
             },
             sensor_attributes: {
               data_pin: '',
               onewire_index: ''
             }
           }
    end
    assert_template :new
  end

  test 'should get update thermostat' do
    patch :update,
          id: @thermostat,
          thermostat: {
            rhizome: @equipment_profile.id,
            element_attributes: {
              control_pin: 'D2',
              power_pin: 'D3'
            },
            sensor_attributes: {
              data_pin: 'D4',
              onewire_index: '0'
            }
          }
    assert_redirected_to equipment_profiles_path
  end

  test 'should not update thermostat' do
    patch :update,
          id: @thermostat,
          thermostat: {
            rhizome: @equipment_profile.id,
            element_attributes: {
              control_pin: '',
              power_pin: ''
            },
            sensor_attributes: {
              data_pin: '',
              onewire_index: ''
            }
          }
    assert_template :edit
  end

  test 'should get destroy thermostat' do
    assert_difference('Thermostat.count', -1) do
      delete :destroy, id: @thermostat.id
    end
    assert_redirected_to equipment_profiles_path
  end
end
