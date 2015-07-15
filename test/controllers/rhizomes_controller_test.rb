require 'test_helper'

class RhizomesControllerTest < ActionController::TestCase
  setup do
    @rhizome = rhizomes(:zeus)
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:rhizomes)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create rhizome' do
    assert_difference('Rhizome.count') do
      post :create, rhizome: {  }
    end

    assert_redirected_to rhizome_path(assigns(:rhizome))
  end

  test 'should show rhizome' do
    get :show, id: @rhizome
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @rhizome
    assert_response :success
  end

  test 'should update rhizome' do
    patch :update, id: @rhizome, rhizome: {  }
    assert_redirected_to rhizome_path(assigns(:rhizome))
  end

  test 'should destroy rhizome' do
    assert_difference('Rhizome.count', -1) do
      delete :destroy, id: @rhizome
    end

    assert_redirected_to rhizomes_path
  end
end
