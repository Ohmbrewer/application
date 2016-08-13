require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @schedule = schedules(:one)
  end

  test 'should get schedules index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:schedules)
  end

  test 'should get new schedule' do
    get :new
    assert_response :success
  end

  test 'should create schedule' do
    assert_difference('Schedule.count') do
      post :create,
           schedule: {
             name: 'test'
           }
    end
    assert_redirected_to schedules_url
  end

  test 'should not create schedule' do
    assert_no_difference('Schedule.count') do
      post :create,
           schedule: {
             name: ''
           }
    end
    assert_template :new
  end

  test 'should show schedule' do
    get :show, id: @schedule
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @schedule
    assert_response :success
  end

  test 'should update schedule' do
    @schedule_to_update = schedules(:two)
    patch :update,
          id: @schedule_to_update,
          schedule: {
            name: 'test_update'
          }
    assert_redirected_to schedules_path
  end

  test 'should not update schedule' do
    @schedule_to_update = schedules(:two)
    patch :update,
          id: @schedule_to_update,
          schedule: {
            name: ''
          }
    assert_template :edit
  end

  test 'should destroy schedule' do
    assert_difference('Schedule.count', -1) do
      delete :destroy, id: @schedule
    end

    assert_redirected_to schedules_path
  end
end
