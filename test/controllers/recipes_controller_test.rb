require 'test_helper'

class RecipesControllerTest < ActionController::TestCase
  setup do
    @user = users(:georg_ohm)
    log_in_as(@user)
    @recipe = recipes(:beer)
    @schedule = schedules(:good_schedule)
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

  test 'should not allow generic recipe' do
    get :new, type: 'Recipe'
    assert_redirected_to recipes_path
  end

  test 'should get new beer recipe' do
    get :new, type: 'BeerRecipe'
    assert_response :success
    assert_equal request.path, new_beer_recipe_path
  end

  test 'should get new cider recipe' do
    get :new, type: 'CiderRecipe'
    assert_response :success
    assert_equal request.path, new_cider_recipe_path
  end

  test 'should get new wine recipe' do
    get :new, type: 'WineRecipe'
    assert_response :success
    assert_equal request.path, new_wine_recipe_path
  end

  test 'should get new mead recipe' do
    get :new, type: 'MeadRecipe'
    assert_response :success
    assert_equal request.path, new_mead_recipe_path
  end

  test 'should get new distilling recipe' do
    get :new, type: 'DistillingRecipe'
    assert_response :success
    assert_equal request.path, new_distilling_recipe_path
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
    new_name = 'test_update'
    recipe_to_update = recipes(:beer)
    patch :update,
          id: recipe_to_update,
          recipe: {
            name: new_name
          }
    assert_redirected_to recipes_path
    recipe_to_update.reload
    assert_equal new_name, recipe_to_update.name
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
