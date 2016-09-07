module RecipesHelper
  def sti_recipe_type_path(type = 'recipe', recipe = nil, action = nil)
    send "#{format_sti(action, type, recipe)}_path", recipe
  end

  def format_sti(action, type, recipe)
    action || recipe ? "#{format_action(action)}#{type.underscore}" : type.underscore.pluralize.to_s
  end

  def format_action(action)
    action ? "#{action}_" : ''
  end

  def add_recipe_message(recipe)
    "#{recipe.type.titlecase} <strong>#{recipe.name}</strong> successfully added!"
  end

  def update_recipe_message(recipe)
    "#{recipe.type.titlecase} <strong>#{recipe.name}</strong> successfully updated!"
  end

  def delete_recipe_message(recipe)
    "#{recipe.type.titlecase} <strong>#{recipe.name}</strong> successfully deleted!"
  end

  def delete_multiple_recipes_success_message
    'Recipes deleted!'
  end

  def delete_multiple_recipes_fail_message
    'No Recipes were deleted! Did you select any?'
  end

  def delete_multiple_recipes_mix_message(pre, post)
    "Something strange happened... #{pre - post} Recipes weren't deleted."
  end
end
