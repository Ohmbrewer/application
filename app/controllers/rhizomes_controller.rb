class RhizomesController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :set_rhizome, only: [:show, :edit, :update, :destroy]

  def index
    @rhizomes = Rhizome.paginate(page: params[:page])
  end

  def show
    @rhizome = Rhizome.find(params[:id])
  end

  def new
    @rhizome = Rhizome.new
    @rhizome.build_particle
  end

  def edit
    @rhizome = Rhizome.find(params[:id])
  end

  def create
    @rhizome = Rhizome.new(rhizome_params)

    if @rhizome.save
      flash[:success] = "Added #{@rhizome.name}!"
      redirect_to @rhizome
    else
      render 'new'
    end
  end

  def update
    if @rhizome.update(rhizome_params)
      flash[:success] = "Updated #{@rhizome.name}!"
      redirect_to @rhizome
    else
      render 'edit'
    end
  end

  def destroy
    @rhizome.destroy
    flash[:success] = 'Rhizome deleted'
    redirect_to rhizomes_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rhizome
      @rhizome = Rhizome.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rhizome_params
      params.require(:rhizome).permit(:name, particle_attributes: [:device_id, :access_token])
    end

end
