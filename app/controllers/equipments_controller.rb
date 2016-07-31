class EquipmentsController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :admin_user,
                only: :destroy
  before_action :set_type
  before_action :set_equipment,
                only: [:show, :edit, :update, :destroy]
  before_action :set_equipment_profile,
                only: [:new, :create]

  # == Routes ==

  def index
    @equipments = type_class.paginate(page: params[:page])
  end

  def show
    if params[:id] == 'destroy_multiple'
      destroy_multiple
    end
  end

  def new
    if @type == 'Equipment'
      flash[:danger] = 'You must be more specific about the type of Equipment you wish to create.'
      redirect_to equipments_path
    end
    @equipment = type_class.new
  end

  def edit; end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.valid?
      @equipment_profile.equipments << @equipment
      msg = "#{@equipment.type.titlecase} successfully added to #{@equipment_profile.name}!"

      if @equipment.save
        flash[:success] = msg
        redirect_to equipment_profiles_path
      else
        render action: 'new'
      end
    else
      render action: 'new'
    end
  end

  def update
    if @equipment.update(equipment_params)
      flash[:success] = "#{@equipment.type.titlecase} successfully updated!"
      redirect_to equipment_profiles_path
    else
      render action: 'edit'
    end
  end

  def destroy
    if params[:id] != 'destroy_multiple'
      msg = "#{@type.titlecase} removed"
      unless @equipment.equipment_profile.nil?
        msg = "#{msg} from #{@equipment.equipment_profile.name}!"
      end
      @equipment.destroy
      flash[:success] = msg
      redirect_to equipment_profiles_path
    else
      destroy_multiple
    end
  end

  def destroy_multiple
    ids = Equipment.equipment_types
                   .collect { |t| params[t.pluralize.underscore] }
    pre = Equipment.where(id: ids)
    landing_url = case
                    when pre.all?{|e| !e.equipment_profile.nil? }
                      equipment_profiles_url
                    else
                      equipments_url
                  end
    Equipment.destroy_all(id: ids)
    post = pre.where(id: ids)

    case post.length
      when 0
        flash[:success] = 'Equipment removed!'
      when pre.length
        flash[:danger] = 'Equipment removal failed!'
      else
        flash[:warning] = "Something strange happened... #{pre.length - post.length} pieces of Equipment weren't removed."
    end

    redirect_to landing_url
  end

  private

    def equipment_params
      p = params.require(type.underscore.to_sym)
                .permit(:type, :control_pin, :power_pin,
                        :data_pin, :onewire_index, :equipment_profile)
      if !(p[:equipment_profile].nil? || p[:equipment_profile].empty?)
        unless p[:equipment_profile].is_a? EquipmentProfile
          p[:equipment_profile] = EquipmentProfile.find(p[:equipment_profile])
        end
      else
        p.delete(:equipment_profile)
      end
      p
    end

    def set_equipment
      unless params[:id] == 'destroy_multiple'
        @equipment = type_class.find(params[:id])
        @equipment_profile = @equipment.equipment_profile
      end
    end

    def set_type
      @type = type
    end

    def set_equipment_profile
      # Coming from an Equipment page
      unless params[type.underscore.to_sym].nil?
        unless params[type.underscore.to_sym][:equipment_profile].nil? || params[type.underscore.to_sym][:equipment_profile].empty?
          @equipment_profile = EquipmentProfile.find(params[type.underscore.to_sym][:equipment_profile].to_i)
        end
      end

      # Coming from the Equipment Profile pages
      unless params[:equipment_profile].nil? || params[:equipment_profile].empty?
        @equipment_profile = EquipmentProfile.find(params[:equipment_profile].to_i)
      end
    end

    def type
      Equipment.equipment_types.include?(params[:type]) ? params[:type] : 'Equipment'
    end

    def type_class
      type.constantize
    end

end
