class Recipe < ActiveRecord::Base

  belongs_to :schedule, dependent: :destroy

  # == Subclass scopes ==
  # These scopes make so anything that references Recipe generally
  # may also reference each of these subclasses specifically, automagically.
  scope :beer_recipes, -> { where(type: 'BeerRecipe') }
  scope :distilling_recipes, -> { where(type: 'DistillingRecipe') }
  scope :cider_recipes, -> { where(type: 'CiderRecipe') }

  # == Other Scopes ==
  scope :non_batch_records, -> { where(batch_id: nil) }
  scope :batch_records, -> { where.not(batch_id: nil) }

  accepts_nested_attributes_for :schedule

  def is_basic_recipe?
    type == 'Recipe'
  end

  def deep_dup
    new_recipe = super
    new_recipe.name = "#{new_recipe.name} (Copy)"

    new_recipe.schedule = schedule.deep_dup

    new_recipe
  end

  class << self

    # TODO: Move this out into a table of available Recipe Types
    # The list of supported Recipe types
    def recipe_types
      %w(BeerRecipe CiderRecipe DistillingRecipe MeadRecipe WineRecipe)
    end

    def available_recipes_options
      non_batch_records.map { |et| [et.name, et.id] }
    end

  end

end
