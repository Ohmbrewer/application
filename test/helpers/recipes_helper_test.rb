require 'test_helper'

class RecipesHelperTest < ActionView::TestCase
  def setup; end

  test 'creates a successful multiple delete message' do
    assert_equal 'Recipes deleted!', delete_multiple_recipes_success_message
  end

  test 'creates an unsuccessful multiple delete message' do
    assert_equal 'No Recipes were deleted! Did you select any?', delete_multiple_recipes_fail_message
  end

  test 'creates a somewhat successful multiple delete message' do
    assert_equal "Something strange happened... 1 Recipes weren't deleted.",
                 delete_multiple_recipes_mix_message(2, 1)
  end
end
