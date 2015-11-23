class RecirculatingInfusionMashSystemsController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :set_rims, only: [:show, :edit, :update, :destroy]
  before_action :set_rhizome,
                only: [:new, :create]


  def index
    @recirculating_infusion_mash_systems = RecirculatingInfusionMashSystem.paginate(page: params[:page])
  end

  def show
    if params[:id] == 'destroy_multiple'
      destroy_multiple
    end
  end

  def new
    @recirculating_infusion_mash_system = RecirculatingInfusionMashSystem.new
    @recirculating_infusion_mash_system.build_subsystems
  end

  def edit; end

  def create
    @recirculating_infusion_mash_system = RecirculatingInfusionMashSystem.new(rims_params)

    if @recirculating_infusion_mash_system.valid?
      @rhizome.recirculating_infusion_mash_systems << @recirculating_infusion_mash_system
      msg = "RIMS successfully added to #{@rhizome.name}!"
      if @recirculating_infusion_mash_system.save
        flash[:success] = msg
        redirect_to rhizomes_path
      else
        render action: 'new'
      end
    else
      render action: 'new'
    end
  end

  def update
    if @recirculating_infusion_mash_system.update(rims_params)
      flash[:success] = 'RIMS successfully updated!'
      redirect_to @recirculating_infusion_mash_system
    else
      render 'edit'
    end
  end

  def destroy
    if params[:id] != 'destroy_multiple'
      msg = "RIMS removed from #{@recirculating_infusion_mash_system.rhizome.name}!"
      @recirculating_infusion_mash_system.destroy
      flash[:success] = msg
      redirect_to rhizomes_path
    else
      destroy_multiple
    end
  end

  def destroy_multiple
    pre = RecirculatingInfusionMashSystem.where(id: params[:recirculating_infusion_mash_systems])
    RecirculatingInfusionMashSystem.destroy_all(id: params[:recirculating_infusion_mash_systems])
    post = pre.where(id: params[:recirculating_infusion_mash_systems])

    case post.length
      when 0
        flash[:success] = 'RIMS removed!'
      when pre.length
        flash[:danger] = 'RIMS removal failed!'
      else
        flash[:warning] = "Something strange happened... #{pre.length - post.length} pieces of RIMS equipment weren't removed."
    end

    redirect_to rhizomes_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_rims
    unless params[:id] == 'destroy_multiple'
      @recirculating_infusion_mash_system = RecirculatingInfusionMashSystem.find(params[:id]) unless params[:id].to_i.zero?
      @rhizome = @recirculating_infusion_mash_system.rhizome
    end
  end

  def set_rhizome
    # Coming from a RIMS page
    unless params[:recirculating_infusion_mash_system].nil?
      unless params[:recirculating_infusion_mash_system][:rhizome].nil?
        @rhizome = Rhizome.find(params[:recirculating_infusion_mash_system][:rhizome].to_i)
      end
    end

    # Coming from the Rhizome pages
    unless params[:rhizome].nil?
      @rhizome = Rhizome.find(params[:rhizome].to_i)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def rims_params
    p = params.require(:recirculating_infusion_mash_system)
            .permit(:rhizome,
                    tube_attributes: [
                        :id,
                        sensor_attributes: [:id, :onewire_id, :data_pin],
                        element_attributes: [:id, :control_pin, :power_pin]
                    ],
                    safety_sensor_attributes: [:id, :onewire_id, :data_pin],
                    recirculation_pump_attributes: [:id, :control_pin, :power_pin])
    unless p[:rhizome].nil?
      unless p[:rhizome].is_a? Rhizome
        p[:rhizome] = Rhizome.find(p[:rhizome])
        p[:tube_attributes][:rhizome] = p[:rhizome]
        p[:safety_sensor_attributes][:rhizome] = p[:rhizome]
        p[:recirculation_pump_attributes][:rhizome] = p[:rhizome]
      end
    end
    p
  end
  
end
