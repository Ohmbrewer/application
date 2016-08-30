require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @schedule = schedules(:good_schedule)
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

  test 'should not create schedule when no EquipmentProfiles' do
    EquipmentProfile.all.each(&:delete)

    get :new
    assert_redirected_to schedules_url
    assert_equal 'You may not create a Schedule until you have defined at least one Equipment Profile.', flash[:warning]
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
    new_name = 'test_update'
    patch :update,
          id: @schedule,
          schedule: {
            name: new_name
          }
    assert_redirected_to schedules_path
    @schedule.reload
    assert_equal new_name, @schedule.name
  end

  test 'should not update schedule' do
    @schedule_to_update = schedules(:good_schedule)
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

  test 'should destroy multiple schedules' do
    schedule_2 = schedules(:small_schedule)
    assert_difference('Schedule.count', -2) do
      delete :destroy_multiple,
             schedules: [@schedule, schedule_2]
    end
    assert_redirected_to schedules_path
  end
end
