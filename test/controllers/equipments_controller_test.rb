require 'test_helper'

class EquipmentsControllerTest < ActionController::TestCase
  setup do
    @equipment_profile = equipment_profiles(:equipment_profile_one)
    @temp_sensor = equipments(:good_rims_therm_sensor)
    @pump = equipments(:good_pump)
    @user = users(:georg_ohm)
    log_in_as(@user)
    @heater = equipments(:heating_element_2pin)
  end

  test 'should get index' do
    get :index
    assert_response :success
  end

  test 'should get equipment show' do
    get :show, id: @pump.id
    assert_response :success
  end

  test 'should get new equipment' do
    get :new, rhizome: @rhizome, type: @temp_sensor.type
    assert_response :success
  end

  test 'should not allow generic equipment' do
    get :new, equipment_profile: @equipment_profile, type: 'Equipment'
    assert_redirected_to equipments_path
  end

  test 'should get edit equipment' do
    get :edit, id: @temp_sensor
    assert_response :success
  end

  test 'should get create equipment' do
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

  test 'should not create equipment' do
    assert_no_difference('Equipment.count') do
      post :create,
           equipment: {
             type: @heater.type,
             equipment_profile: @equipment_profile,
             control_pin: '',
             power_pin: ''
           }
    end
    assert_template :new
  end

  test 'should get update equipment' do
    new_onewire_index = '5'
    patch :update,
          id: @temp_sensor.id,
          equipment: {
            equipment_profile: @equipment_profile,
            type: @temp_sensor.type,
            onewire_index: new_onewire_index
          }
    assert_redirected_to equipment_profiles_path
    @temp_sensor.reload
    assert_equal new_onewire_index, @temp_sensor.onewire_index
  end

  test 'should not update equipment' do
    patch :update,
          id: @temp_sensor.id,
          equipment: {
            type: @temp_sensor.type,
            onewire_index: ''
          }
    assert_template :edit
  end

  test 'should update equipment\'s equipment profile' do
    patch :update, id: @temp_sensor.id, equipment: { type: @temp_sensor.type, equipment_profile: @equipment_profile.id }
    assert_equal @equipment_profile.id, @temp_sensor.equipment_profile.id
  end

  test 'should get destroy equipment' do
    assert_difference('Equipment.count', -1) do
      delete :destroy, id: @temp_sensor
    end
    assert_redirected_to equipment_profiles_path
  end

  test 'should destroy multiple equipment' do
    temp_sensor_2 = equipments(:good_rims_safety_sensor)

    assert_difference('Equipment.count', -2) do
      delete :destroy_multiple,
             temperature_sensors: [@temp_sensor, temp_sensor_2]
    end
    assert_redirected_to equipments_path
  end

  test 'should not destroy multiple equipment' do
    assert_no_difference('Equipment.count') do
      delete :destroy_multiple,
             temperature_sensors: []
    end
    assert_redirected_to equipment_profiles_path
  end
end
