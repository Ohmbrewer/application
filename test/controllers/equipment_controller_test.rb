require 'test_helper'

class EquipmentsControllerTest < ActionController::TestCase
  setup do
    @rhizome = rhizomes(:rhizomes_001)
    @rhizome_create = rhizomes(:rhizomes_003)
    @temp_sensor = equipments(:equipments_002)
    @pump =  equipments(:equipments_004)
    @user = users(:users_001)
    log_in_as(@user)
    @heater = equipments(:equipments_005)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show, id: @pump.id
    assert_response :success
  end

  test "should get new" do
    get :new, rhizome: @rhizome, type: @temp_sensor.type
    assert_response :success
  end

  test "should not allow generic equipment" do
    get :new, rhizome: @rhizome, type: 'Equipment'
    assert_redirected_to rhizomes_path
  end

  test "should get edit" do
    get :edit, id: @temp_sensor
    assert_response :success
  end

  test "should get create" do
    assert_difference('Equipment.count') do
      post :create, equipment: {type: @heater.type, rhizome: @rhizome_create.id, control_pin: @heater.control_pin, power_pin: @heater.power_pin}
    end
    assert_redirected_to rhizomes_path
  end

  test "should get update" do
    patch :update, id: @temp_sensor.id, equipment: {type: @temp_sensor.type, rhizome: @rhizome_create.id, onewire_index: "0", data_pin: @heater.power_pin}
    assert @temp_sensor.onewire_index = "0"
  end

  test "should get destroy" do
    assert_difference('Equipment.count', -1) do
      delete :destroy, id: @temp_sensor
    end
    assert_redirected_to rhizomes_path
  end

end
