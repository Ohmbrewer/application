require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @recipe = recipes(:beer)
    @schedule = schedules(:one)
  end

  test 'should get recipes index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:recipes)
  end

  test 'should get new recipe' do
    get :new, type: 'BeerRecipe'
    assert_response :success
  end

  test 'should create recipe' do
    assert_difference('Recipe.count') do
      post :create,
           recipe: {
             name: 'test',
             type: 'WineRecipe',
             schedule_id: @schedule
           }
    end
    assert_redirected_to recipes_url
  end

  test 'should not create recipe' do
    assert_no_difference('Recipe.count') do
      post :create,
           recipe: {
             name: '',
             type: 'Recipe'
           }
    end
    assert_template :new
  end

  test 'should show recipe' do
    get :show, id: @recipe
    assert_response :success
  end

  test 'should get edit recipe' do
    get :edit, id: @recipe
    assert_response :success
  end

  test 'should update recipe' do
    @recipe_to_update = recipes(:beer)
    patch :update,
          id: @recipe_to_update,
          recipe: {
            name: 'test_update'
          }
    assert_redirected_to recipes_path
  end

  test 'should not update recipe' do
    @recipe_to_update = recipes(:beer)
    patch :update,
          id: @recipe_to_update,
          recipe: {
            name: ''
          }
    assert_template :edit
  end

  test 'should destroy recipe' do
    assert_difference('Recipe.count', -1) do
      delete :destroy, id: @recipe
    end

    assert_redirected_to recipes_path
  end
end
