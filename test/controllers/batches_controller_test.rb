require 'test_helper'

class BatchesControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @recipe = recipes(:beer)
    @batch = batches(:good_beer_batch)
  end

  test 'should get batches index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:batches)
  end

  test 'should get new batch' do
    get :new, type: 'BeerBatch'
    assert_response :success
  end

  test 'should create batch' do
    assert_difference('Batch.count') do
      post :create,
           batch: {
             type: 'BeerBatch',
             recipe: @recipe
           }
    end
    assert_redirected_to batch_assign_rhizomes_path(assigns(:batch))
  end

  test 'should not create batch' do
    assert_no_difference('Batch.count') do
      post :create,
           batch: {
             name: '',
             type: 'Batch'
           }
    end
    assert_template :new
  end

  test 'should show batch' do
    get :show, id: @batch
    assert_response :success
  end

  # test 'should destroy batch' do
  #   assert_difference('Batch.count', -1) do
  #     delete :destroy, id: @batch
  #   end
  #
  #   assert_redirected_to batches_path
  # end
end
