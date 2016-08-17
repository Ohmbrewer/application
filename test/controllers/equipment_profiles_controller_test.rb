require 'test_helper'

class EquipmentProfilesControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @equipment_profile = equipment_profiles(:one)
  end

  test 'should get equipment profiles index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:equipment_profiles)
  end

  test 'should get new equipment profile' do
    get :new
    assert_response :success
  end

  test 'should create equipment profile' do
    assert_difference('EquipmentProfile.count') do
      post :create,
           equipment_profile: {
             name: 'test'
           }
    end
    assert_redirected_to equipment_profiles_url
  end

  test 'should not create equipment profile' do
    assert_no_difference('EquipmentProfile.count') do
      post :create,
           equipment_profile: {
             name: ''
           }
    end
    assert_template :new
  end

  test 'should show equipment profile' do
    get :show, id: @equipment_profile
    assert_response :success
  end

  test 'should get edit equipment profile' do
    get :edit, id: @equipment_profile
    assert_response :success
  end

  test 'should update equipment profile' do
    @equipment_profile_to_update = equipment_profiles(:two)
    patch :update,
          id: @equipment_profile_to_update,
          equipment_profile: {
            name: 'test_update'
          }
    assert_redirected_to equipment_profiles_path
  end

  test 'should not update equipment profile' do
    @equipment_profile_to_update = equipment_profiles(:two)
    patch :update,
          id: @equipment_profile_to_update,
          equipment_profile: {
            name: ''
          }
    assert_template :edit
  end

  test 'should destroy equipment profile' do
    assert_difference('EquipmentProfile.count', -1) do
      delete :destroy, id: @equipment_profile
    end

    assert_redirected_to equipment_profiles_path
  end
end
