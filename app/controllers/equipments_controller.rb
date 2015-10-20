class EquipmentsController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :admin_user,
                only: :destroy
  before_action :set_type
  before_action :set_equipment,
                only: [:show, :edit, :update, :destroy]
  before_action :set_rhizome,
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
      redirect_to rhizomes_path
    end
    @equipment = type_class.new
  end

  def edit; end

  def create
    @equipment = Equipment.new(equipment_params)
    if @equipment.valid?
      @rhizome.equipments << @equipment
      msg = "#{@equipment.type.titlecase} successfully added to #{@rhizome.name}!"
      if @equipment.save
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
    if @equipment.update(equipment_params)
      flash[:success] = "#{@equipment.type.titlecase} successfully updated!"
      redirect_to rhizomes_path
    else
      render action: 'edit'
    end
  end

  def destroy
    if params[:id] != 'destroy_multiple'
      msg = "#{@type.titlecase} removed from #{@equipment.rhizome.name}!"
      @equipment.destroy
      flash[:success] = msg
      redirect_to rhizomes_path
    else
      destroy_multiple
    end
  end

  def destroy_multiple
    ids = Equipment.equipment_types
                   .collect { |t| params[t.pluralize.underscore] }
    pre = Equipment.where(id: ids)
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

    redirect_to rhizomes_url
  end

  private

    def equipment_params
      p = params.require(type.underscore.to_sym)
                .permit(:type, :control_pin, :power_pin,
                        :data_pin, :onewire_id, :rhizome)
      unless p[:rhizome].nil?
        unless p[:rhizome].is_a? Rhizome
          p[:rhizome] = Rhizome.find(p[:rhizome])
        end
      end
      p
    end

    def set_equipment
      unless params[:id] == 'destroy_multiple'
        @equipment = type_class.find(params[:id])
        @rhizome = @equipment.rhizome
      end
    end

    def set_type
      @type = type
    end

    def set_rhizome
      # Coming from an Equipment page
      unless params[type.underscore.to_sym].nil?
        unless params[type.underscore.to_sym][:rhizome].nil?
          @rhizome = Rhizome.find(params[type.underscore.to_sym][:rhizome].to_i)
        end
      end

      # Coming from the Rhizome pages
      unless params[:rhizome].nil?
        @rhizome = Rhizome.find(params[:rhizome].to_i)
      end
    end

    def type
      Equipment.equipment_types.include?(params[:type]) ? params[:type] : 'Equipment'
    end

    def type_class
      type.constantize
    end

end
