require 'test_helper'

class EquipmentsControllerTest < ActionController::TestCase
  setup do
    @equipment_profile = equipment_profiles(:one)
    @temp_sensor = equipments(:temperature_sensor_2)
    @pump = equipments(:pump)
    @user = users(:georg_ohm)
    log_in_as(@user)
    @heater = equipments(:heating_element_2pin)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get show' do
    get :show, id: @pump.id
    assert_response :success
  end

  test 'should get new' do
    get :new, rhizome: @rhizome, type: @temp_sensor.type
    assert_response :success
  end

  test 'should not allow generic equipment' do
    get :new, equipment_profile: @equipment_profile, type: 'Equipment'
    assert_redirected_to equipments_path
  end

  test 'should get edit' do
    get :edit, id: @temp_sensor
    assert_response :success
  end

  test 'should get create' do
    assert_difference('Equipment.count') do
      post :create,
           equipment: {
             type: @heater.type,
             equipment_profile: @equipment_profile.id,
             control_pin: @heater.control_pin,
             power_pin: @heater.power_pin
           }
    end
    assert_redirected_to equipment_profiles_path
  end

  test 'should get update' do
    new_onewire_index = '5'
    patch :update, id: @temp_sensor.id, equipment: { type: @temp_sensor.type, onewire_index: new_onewire_index }
    assert_redirected_to equipment_profiles_path
    @temp_sensor.reload
    assert_equal new_onewire_index, @temp_sensor.onewire_index
  end

  test 'should update equipment profile' do
    patch :update, id: @temp_sensor.id, equipment: { type: @temp_sensor.type, equipment_profile: @equipment_profile.id }
    assert_equal @equipment_profile.id, @temp_sensor.equipment_profile.id
  end

  test 'should get destroy' do
    assert_difference('Equipment.count', -1) do
      delete :destroy, id: @temp_sensor
    end
    assert_redirected_to equipment_profiles_path
  end
end
