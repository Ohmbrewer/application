require 'test_helper'

class RhizomesControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @rhizome = rhizomes(:rhizomes_001)
  end

  test 'should get rhizomes index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:rhizomes)
  end

  test 'should get new rhizome' do
    get :new
    assert_response :success
  end

  test 'should create rhizome' do
    assert_difference('Rhizome.count') do
      post :create,
           rhizome: {
             name: 'test',
             particle_device_attributes: {
               device_id: '123456789012345678901234',
               access_token: '1234567890123456789012345678901234567890'
             }
           }
    end
    assert_redirected_to rhizomes_url
  end

  test 'should not create rhizome' do
    assert_no_difference('Rhizome.count') do
      post :create,
           rhizome: {
             name: ''
           }
    end
    assert_template :new
  end

  test 'should show rhizome' do
    get :show, id: @rhizome
    assert_response :success
  end

  test 'should get edit rhizome' do
    get :edit, id: @rhizome
    assert_response :success
  end

  test 'should update rhizome' do
    @rhizome_to_update = rhizomes(:rhizomes_002)
    patch :update,
          id: @rhizome_to_update,
          rhizome: {
            name: 'test_update',
            particle_device_attributes: {
              device_id: '360018000347341137373739',
              access_token: '1234567890123456789012345678901234567890'
            }
          }
    assert_redirected_to rhizome_path(assigns(:rhizome))
  end

  test 'should not update rhizome' do
    @rhizome_to_update = rhizomes(:rhizomes_002)
    patch :update,
          id: @rhizome_to_update,
          rhizome: {
            name: ''
          }
    assert_template :edit
  end

  test 'should destroy rhizome' do
    assert_difference('Rhizome.count', -1) do
      delete :destroy, id: @rhizome
    end

    assert_redirected_to rhizomes_path
  end
end
