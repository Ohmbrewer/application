class ThermostatsController < ApplicationController
  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :set_thermostat, only: [:show, :edit, :update, :destroy]
  before_action :set_equipment_profile,
                only: [:new, :create]

  def index
    @thermostats = Thermostat.paginate(page: params[:page])
  end

  def show; end

  def new
    @thermostat = Thermostat.new
    @thermostat.build_subsystems
  end

  def edit; end

  def create
    @thermostat = Thermostat.new(thermostat_params)

    if @thermostat.valid?
      owner = @equipment_profile

      owner.thermostats << @thermostat
      msg = "Thermostat successfully added to <strong>#{owner.name}</strong>!"
      if @thermostat.save
        flash[:success] = msg
        redirect_to equipment_profiles_path
        return
      end
    end

    render :new
  end

  def update
    if @thermostat.update(thermostat_params)
      flash[:success] = 'Thermostat successfully updated!'
      redirect_to equipment_profiles_path
    else
      render 'edit'
    end
  end

  def destroy
    msg = 'Thermostat removed'
    unless @thermostat.equipment_profile.nil?
      msg = "#{msg} from <strong>#{@thermostat.equipment_profile.name}</strong>!"
    end
    @thermostat.destroy
    flash[:success] = msg
    redirect_to equipment_profiles_path
  end

  def destroy_multiple
    pre = Thermostat.where(id: params[:thermostats])
    landing_url = case
                  when pre.all? { |e| !e.equipment_profile.nil? }
                    equipment_profiles_url
                  else
                    thermostats_url
                  end
    Thermostat.destroy_all(id: params[:thermostats])
    post = pre.where(id: params[:thermostats])

    case post.length
    when pre.length
      flash[:danger] = 'No Thermostats were removed. Did you select any?'
    when 0
      flash[:success] = 'Thermostats removed!'
    else
      flash[:warning] = "Something strange happened... #{pre.length - post.length} Thermostats weren't removed."
    end

    redirect_to landing_url
  end

  private

    def set_thermostat
      unless params[:id] == 'destroy_multiple'
        @thermostat = Thermostat.find(params[:id]) unless params[:id].to_i.zero?
        @equipment_profile = @thermostat.equipment_profile
      end
    end

    def set_equipment_profile
      # Coming from a Thermostat page
      unless params[:thermostat].nil?
        unless params[:thermostat][:equipment_profile].nil? || params[:thermostat][:equipment_profile].empty?
          @equipment_profile = EquipmentProfile.find(params[:thermostat][:equipment_profile].to_i)
        end
      end

      # Coming from the Equipment Profile pages
      unless params[:equipment_profile].nil? || params[:equipment_profile].empty?
        @equipment_profile = EquipmentProfile.find(params[:equipment_profile].to_i)
      end
    end

    def thermostat_params
      p = params.require(:thermostat)
                .permit(:equipment_profile,
                        sensor_attributes: [:id, :onewire_index, :data_pin],
                        element_attributes: [:id, :control_pin, :power_pin])
      if !(p[:equipment_profile].nil? || p[:equipment_profile].empty?)
        unless p[:equipment_profile].is_a? EquipmentProfile
          p[:equipment_profile] = EquipmentProfile.find(p[:equipment_profile])
          p[:sensor_attributes][:equipment_profile] = p[:equipment_profile]
          p[:element_attributes][:equipment_profile] = p[:equipment_profile]
        end
      else
        p.delete(:equipment_profile)
      end
      p
    end
end
