class RecirculatingInfusionMashSystemsController < ApplicationController
  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :set_rims, only: [:show, :edit, :update, :destroy]
  before_action :set_equipment_profile,
                only: [:new, :create]

  def index
    @recirculating_infusion_mash_systems = RecirculatingInfusionMashSystem.paginate(page: params[:page])
  end

  def show; end

  def new
    @recirculating_infusion_mash_system = RecirculatingInfusionMashSystem.new
    @recirculating_infusion_mash_system.build_subsystems
  end

  def edit; end

  def create
    @recirculating_infusion_mash_system = RecirculatingInfusionMashSystem.new(rims_params)

    if @recirculating_infusion_mash_system.valid?
      @equipment_profile.recirculating_infusion_mash_systems << @recirculating_infusion_mash_system
      msg = "RIMS successfully added to <strong>#{@equipment_profile.name}</strong>!"
      if @recirculating_infusion_mash_system.save
        flash[:success] = msg
        redirect_to equipment_profiles_path
        return
      end
    end

    render :new
  end

  def update
    if @recirculating_infusion_mash_system.update(rims_params)
      flash[:success] = 'RIMS successfully updated!'
      redirect_to equipment_profiles_path
    else
      render 'edit'
    end
  end

  def destroy
    msg = 'RIMS removed'
    unless @recirculating_infusion_mash_system.equipment_profile.nil?
      msg = "#{msg} from <strong>#{@recirculating_infusion_mash_system.equipment_profile.name}</strong>!"
    end
    @recirculating_infusion_mash_system.destroy
    flash[:success] = msg
    redirect_to equipment_profiles_path
  end

  def destroy_multiple
    pre = RecirculatingInfusionMashSystem.where(id: params[:recirculating_infusion_mash_systems])
    landing_url = case
                  when pre.all?{ |e| !e.equipment_profile.nil? }
                    equipment_profiles_url
                  else
                    recirculating_infusion_mash_systems_url
                  end
    RecirculatingInfusionMashSystem.destroy_all(id: params[:recirculating_infusion_mash_systems])
    post = pre.where(id: params[:recirculating_infusion_mash_systems])

    case post.length
    when pre.length
      flash[:danger] = 'No RIMS were removed. Did you select any?'
    when 0
      flash[:success] = 'RIMS removed!'
    else
      flash[:warning] = "Something strange happened... #{pre.length - post.length} RIMS weren't removed."
    end

    redirect_to landing_url
  end

  private

    def set_rims
      unless params[:id] == 'destroy_multiple'
        @recirculating_infusion_mash_system = RecirculatingInfusionMashSystem.find(params[:id]) unless params[:id].to_i.zero?
        @equipment_profile = @recirculating_infusion_mash_system.equipment_profile
      end
    end

    def set_equipment_profile
      # Coming from a RIMS page
      unless params[:recirculating_infusion_mash_system].nil?
        unless params[:recirculating_infusion_mash_system][:equipment_profile].blank?
          @equipment_profile = EquipmentProfile.find(params[:recirculating_infusion_mash_system][:equipment_profile].to_i)
        end
      end

      # Coming from the Equipment Profile pages
      unless params[:equipment_profile].blank?
        @equipment_profile = EquipmentProfile.find(params[:equipment_profile].to_i)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rims_params
      p = params.require(:recirculating_infusion_mash_system)
                .permit(:equipment_profile,
                        tube_attributes: [
                          :id,
                          sensor_attributes: [:id, :onewire_index, :data_pin],
                          element_attributes: [:id, :control_pin, :power_pin]
                        ],
                        safety_sensor_attributes: [:id, :onewire_index, :data_pin],
                        recirculation_pump_attributes: [:id, :control_pin, :power_pin])
      if p[:equipment_profile].present?
        unless p[:equipment_profile].is_a? EquipmentProfile
          p[:equipment_profile] = EquipmentProfile.find(p[:equipment_profile].to_i)
          p[:tube_attributes][:equipment_profile] = p[:equipment_profile]
          p[:tube_attributes][:sensor_attributes][:equipment_profile] = p[:equipment_profile]
          p[:tube_attributes][:element_attributes][:equipment_profile] = p[:equipment_profile]
          p[:safety_sensor_attributes][:equipment_profile] = p[:equipment_profile]
          p[:recirculation_pump_attributes][:equipment_profile] = p[:equipment_profile]
        end
      else
        p.delete(:equipment_profile)
      end
      p
    end
end
