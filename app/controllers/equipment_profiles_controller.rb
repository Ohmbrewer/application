class EquipmentProfilesController < ApplicationController
  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :set_equipment_profile, only: [:show, :edit, :update, :destroy]

  def index
    @equipment_profiles = EquipmentProfile.paginate(page: params[:page])
  end

  def show
    @equipment_profile = EquipmentProfile.find(params[:id])
  end

  def new
    @equipment_profile = EquipmentProfile.new
  end

  def edit
    @equipment_profile = EquipmentProfile.find(params[:id])
  end

  def create
    @equipment_profile = EquipmentProfile.new(equipment_profile_params)

    if @equipment_profile.save
      flash[:success] = "Added <strong>#{@equipment_profile.name.html_safe}</strong>!"
      redirect_to equipment_profiles_url
    else
      render 'new'
    end
  end

  def update
    if @equipment_profile.update(equipment_profile_params)
      flash[:success] = "Updated <strong>#{@equipment_profile.name.html_safe}</strong>!"
      redirect_to equipment_profiles_url
    else
      render 'edit'
    end
  end

  def destroy
    if !params[:heating_elements].nil? || !params[:temperature_sensors].nil? ||
       !params[:pumps].nil? || !params[:equipments].nil?
      redirect_to controller: :equipments, action: :destroy_multiple, params: params
    elsif params[:equipment_profiles].nil?

      if @equipment_profile.nil?
        flash[:danger] = 'No EquipmentProfile selected!'
      else
        name = @equipment_profile.name.html_safe
        @equipment_profile.destroy
        flash[:success] = "Deleted <strong>#{name}</strong>"
      end

      redirect_to equipment_profiles_url
    end
  end

  def duplicate
    if params[:equipment_profile_id].nil?
      flash[:danger] = 'Could not duplicate Equipment Profile. No Equipment Profile identified!'
      redirect_to equipment_profiles_path
    else
      old_equipment_profile = EquipmentProfile.find(params[:equipment_profile_id].to_i)
      @equipment_profile = old_equipment_profile.deep_dup

      msg = "Duplicated <strong>#{old_equipment_profile.name}</strong>."

      if @equipment_profile.save
        flash[:success] = msg
        redirect_to equipment_profiles_path
      else
        flash[:warning] = "Tried to duplicate #{@equipment_profile.name}, but something went wrong!"
        render 'new'
      end
    end
  end

  def destroy_multiple
    pre = EquipmentProfile.where(id: params[:equipment_profiles])
    EquipmentProfile.destroy_all(id: params[:equipment_profiles])
    post = pre.where(id: params[:equipment_profiles])

    case post.length
    when pre.length
      flash[:danger] = 'No Equipment Profiles were deleted. Did you select any?'
    when 0
      flash[:success] = 'Equipment Profiles deleted'
    else
      flash[:warning] = "Something strange happened... #{pre.length - post.length} Equipment Profiles weren't deleted."
    end

    redirect_to equipment_profiles_url
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_equipment_profile
      @equipment_profile = EquipmentProfile.find(params[:id]) unless params[:id].to_i.zero?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def equipment_profile_params
      params.require(:equipment_profile).permit(:name)
    end
end
