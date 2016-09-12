class BatchesController < ApplicationController
  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :set_batch, only: [:show, :assign_rhizomes, :update_rhizomes,
                                   :start, :stop, :destroy]
  before_action :create_dup_recipe, only: [:create]

  def index
    @batches = Batch.paginate(page: params[:page])
  end

  def show
    @batch = Batch.find(params[:id])
  end

  def new
    @batch = Batch.new
  end

  def assign_rhizomes
    if @batch.not_ready? || @batch.ready?
      unless @batch.rhizome_roles.length == @batch.recipe.schedule.equipment_profiles.length
        @batch.recipe.schedule.equipment_profiles.each do
          @batch.rhizome_roles.build
        end
      end
    elsif @batch.running?
      flash[:danger] = "#{@batch.name} has already started and it's Rhizomes may not be modified. " <<
                       'If you need to use those Rhizomes for another Batch, either wait for the ' <<
                       'Batch to finish or stop the process early. ' <<
                       'Once the Batch exits the Running state the Rhizomes will be available again.'
    else
      flash[:danger] = "#{@batch.name} has already been run. Its Rhizomes are only listed for reference."
    end
  end

  def create
    @batch = Batch.new(batch_params.merge(recipe: @recipe))

    if @batch.save
      @batch.reload

      flash[:success] = "Added <strong>#{@batch.name.html_safe}</strong>!"
      redirect_to batch_assign_rhizomes_path(@batch)
    else
      @recipe.destroy unless @recipe.nil?
      render 'new'
    end
  end

  def update_rhizomes
    if @batch.update(assign_rhizomes_params)
      flash[:success] = "Ready to Run <strong>#{@batch.name.html_safe}</strong>!"
      redirect_to batches_url
    else
      render 'assign_rhizomes'
    end
  end

  def start
    if @batch.may_start?
      result = @batch.attempt_to_run
      flash[result.first] = result.second
      redirect_to @batch
    else
      flash[:danger] = "<strong>#{@batch.name.html_safe}</strong> is not ready to start. " <<
                       'Please verify that all Rhizomes assigned to the batch ' <<
                       'are available for use and try again.'
      redirect_to batches_url
    end
  end

  def stop
    if @batch.may_stop?
      result = @batch.attempt_to_stop
      flash[result.first] = result.second
      redirect_to @batch
    else
      flash[:danger] = "<strong>#{@batch.name.html_safe}</strong> may not be stopped. " <<
                       'Is it even running?'
      redirect_to batches_url
    end
  end

  def destroy
    if @batch.nil?
      flash[:danger] = 'No Batch selected!'
    else
      name = @batch.name.html_safe
      @batch.destroy
      flash[:success] = "Deleted <strong>#{name}</strong>"
    end

    redirect_to batches_url
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_batch
      @batch = Batch.find(params[:id]) unless params[:id].to_i.zero?
      @batch = Batch.find(params[:batch_id]) unless params[:batch_id].to_i.zero?
    end

    def create_dup_recipe
      recipe_to_dup = batch_params[:recipe]
      unless recipe_to_dup.nil?
        @recipe = recipe_to_dup.deep_dup
        @recipe.schedule.name.gsub!('Copy', "##{Recipe.count}")
        @recipe.name.gsub!('Copy', "##{Recipe.count}")
        @recipe.save(validate: false)
        @recipe.schedule.copy_root_task_task_index(recipe_to_dup.schedule)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def batch_params
      p = params.require(:batch).permit(:recipe,
                                        rhizome_roles_attributes: [:rhizome_id, :role_id, :_destroy])
      if p[:recipe].to_i.zero?
        p.delete(:recipe)
      else
        p[:recipe] = Recipe.find(p[:recipe].to_i)
      end
      p
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assign_rhizomes_params
      params.require(:batch)
            .permit(rhizome_roles_attributes: [:id, :rhizome_id, :role_id])
    end
end
