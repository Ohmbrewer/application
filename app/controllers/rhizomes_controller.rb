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
    @rhizome.build_particle_device
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
    if !params[:heating_elements].nil? || !params[:temperature_sensors].nil? ||
       !params[:pumps].nil? || !params[:equipments].nil?
      redirect_to controller: :equipments,
                  action: :destroy_multiple,
                  params: params
    elsif params[:rhizomes].nil?
      if @rhizome.nil?
        flash[:danger] = 'No Rhizome selected!'
      else
        name = @rhizome.name.html_safe
        @rhizome.destroy
        flash[:success] = "Deleted <strong>#{name}</strong>"
      end

      redirect_to rhizomes_url
    end
  end

  def destroy_multiple
    pre = Rhizome.where(id: params[:rhizomes]).length
    Rhizome.destroy_all(id: params[:rhizomes])
    post = Rhizome.where(id: params[:rhizomes]).length

    case post
    when pre
      flash[:danger] = 'No Rhizomes were deleted. Did you select any?'
    when 0
      flash[:success] = 'Rhizomes deleted!'
    else
      flash[:warning] = "Something strange happened... #{pre - post} Rhizomes weren't deleted."
    end

    redirect_to rhizomes_url
  end

  private

    def set_rhizome
      @rhizome = Rhizome.find(params[:id]) unless params[:id].to_i.zero?
    end

    def rhizome_params
      params.require(:rhizome).permit(:name, particle_device_attributes: [:device_id, :access_token])
    end
end
