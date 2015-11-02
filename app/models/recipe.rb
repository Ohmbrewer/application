class Recipe < ActiveRecord::Base

  belongs_to :schedule

  # == Subclass scopes ==
  # These scopes make so anything that references Recipe generally
  # may also reference each of these subclasses specifically, automagically.
  scope :beer_recipes, -> { where(type: 'BeerRecipe') }
  scope :distilling_recipes, -> { where(type: 'DistillingRecipe') }
  scope :cider_recipes, -> { where(type: 'CiderRecipe') }

  accepts_nested_attributes_for :schedule

  def is_basic_recipe?
    type == 'Recipe'
  end

  class << self

    # TODO: Move this out into a table of available Recipe Types
    # The list of supported Recipe types
    def recipe_types
      %w(BeerRecipe CiderRecipe DistillingRecipe MeadRecipe WineRecipe)
    end

  end

end
