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
      flash[:success] = "Added <strong>#{@rhizome.name.html_safe}</strong>!"
      redirect_to rhizomes_url
    else
      render 'new'
    end
  end

  def update
    if @rhizome.update(rhizome_params)
      flash[:success] = "Updated <strong>#{@rhizome.name.html_safe}</strong>!"
      redirect_to @rhizome
    else
      render 'edit'
    end
  end

  def destroy
    if params[:rhizomes].nil?

      if @rhizome.nil?
        flash[:danger] = 'No Rhizome selected!'
      else
        name = @rhizome.name.html_safe
        @rhizome.destroy
        flash[:success] = "Deleted <strong>#{name}</strong>"
      end

      redirect_to rhizomes_url
    else
      destroy_multiple
    end
  end

  def destroy_multiple
    pre = Rhizome.where(id: params[:rhizomes])
    Rhizome.destroy_all(id: params[:rhizomes])
    post = pre.where(id: params[:rhizomes])

    case post.length
      when 0
        flash[:success] = 'Rhizomes deleted'
      when pre.length
        flash[:danger] = 'Deletion failed!'
      else
        flash[:warning] = "Something strange happened... #{pre.length - post.length} Rhizomes weren't deleted."
    end

    redirect_to rhizomes_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rhizome
      @rhizome = Rhizome.find(params[:id]) unless params[:id].to_i.zero?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rhizome_params
      params.require(:rhizome).permit(:name, particle_attributes: [:device_id, :access_token])
    end

end
