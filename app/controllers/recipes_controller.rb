class RecipesController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :admin_user,
                only: :destroy
  before_action :set_type
  before_action :set_recipe,
                only: [:show, :edit, :update, :destroy]

  # == Routes ==

  def index
    @recipes = type_class.paginate(page: params[:page])
  end

  def show
    if params[:id] == 'destroy_multiple'
      destroy_multiple
    end
  end

  def duplicate
    if params[:recipe_id].nil?
      flash[:danger] = 'Could not duplicate Recipe. No Recipe identified!'
      redirect_to recipes_path
    else
      old_recipe = Recipe.find(params[:recipe_id].to_i)
      @recipe = old_recipe.dup
      @recipe.name = "#{@recipe.name} (Copy)"

      msg = "Duplicated <strong>#{old_recipe.name}</strong>."

      if @recipe.valid?
        if @recipe.save
          flash[:success] = msg
          redirect_to recipe_type_path(@recipe.type)
        else
          render 'new'
        end
      else
        flash[:warning] = "Tried to duplicate #{@recipe.name}, but something went wrong!"
      end
    end
  end

  def new
    if @type == 'Recipe'
      flash[:danger] = 'You must be more specific about the type of Recipe you wish to create.'
      redirect_to recipes_path
    end
    @recipe = type_class.new
  end

  def edit; end

  def create
    @recipe = Recipe.new(recipe_params)
    if @recipe.valid?
      msg = view_context.add_recipe_message(@recipe)
      if @recipe.save
        flash[:success] = msg
        redirect_to recipe_type_path
      else
        render action: 'new'
      end
    else
      render action: 'new'
    end
  end

  def update
    if @recipe.update(recipe_params)
      flash[:success] = view_context.update_recipe_message(@recipe)
      redirect_to recipe_type_path
    else
      render action: 'edit'
    end
  end

  def destroy
    if params[:id] != 'destroy_multiple'
      msg = view_context.delete_recipe_message(@recipe)
      @recipe.destroy
      flash[:success] = msg
      redirect_to recipe_type_path
    else
      destroy_multiple
    end
  end

  def destroy_multiple
    ids = Recipe.recipe_types
              .collect { |t| params[t.pluralize.underscore] }
    pre = Recipe.where(id: ids)
    Recipe.destroy_all(id: ids)
    post = pre.where(id: ids)

    case post.length
      when 0
        flash[:success] = view_context.delete_multiple_recipes_success_message
      when pre.length
        flash[:danger] = view_context.delete_multiple_recipes_fail_message
      else
        flash[:warning] = view_context.delete_multiple_recipes_mix_message(pre.length, post.length)
    end

    redirect_to recipes_url
  end

  private

  def recipe_params
    p = params.require(type.underscore.to_sym)
          .permit(:type, :name, :schedule)
    unless p[:schedule].nil? || p[:schedule].to_i.zero?
      p[:schedule] = Schedule.find(p[:schedule].to_i)
    end
    p
  end

  def set_recipe
    unless params[:id] == 'destroy_multiple'
      @recipe = type_class.find(params[:id])
    end
  end

  def set_type
    @type = type
  end

  def type
    Recipe.recipe_types.include?(params[:type]) ? params[:type] : 'Recipe'
  end

  def type_class
    type.constantize
  end

  def recipe_type_path(type=nil)
    view_context.sti_recipe_type_path(type.nil? ? @type : type)
  end
  
end
