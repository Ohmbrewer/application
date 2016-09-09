require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  test 'should not be basic' do
    beer_recipe = recipes(:beer)
    assert_not beer_recipe.basic_recipe?
  end
end
