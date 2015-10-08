class ThermostatsController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :set_thermostat, only: [:show, :edit, :update, :destroy]
  before_action :set_rhizome,
                only: [:new, :create]

  def index
    @thermostats = Thermostat.paginate(page: params[:page])
  end

  def show
    if params[:id] == 'destroy_multiple'
      destroy_multiple
    end
  end

  def new
    @thermostat = Thermostat.new
    @thermostat.build_subsystems
  end

  def edit; end

  def create
    @thermostat = Thermostat.new(thermostat_params)

    if @thermostat.valid?
      @rhizome.thermostats << @thermostat
      msg = "Thermostat successfully added to #{@rhizome.name}!"
      if @thermostat.save
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
    if @thermostat.update(thermostat_params)
      flash[:success] = 'Thermostat successfully updated!'
      redirect_to @thermostat
    else
      render 'edit'
    end
  end

  def destroy
    if params[:id] != 'destroy_multiple'
      msg = "Thermostat removed from #{@thermostat.rhizome.name}!"
      @thermostat.destroy
      flash[:success] = msg
      redirect_to rhizomes_path
    else
      destroy_multiple
    end
  end

  def destroy_multiple
    pre = Thermostat.where(id: params[:thermostats])
    Thermostat.destroy_all(id: params[:thermostats])
    post = pre.where(id: params[:thermostats])

    case post.length
      when 0
        flash[:success] = 'Thermostat removed!'
      when pre.length
        flash[:danger] = 'Thermostat removal failed!'
      else
        flash[:warning] = "Something strange happened... #{pre.length - post.length} pieces of Thermostat weren't removed."
    end

    redirect_to rhizomes_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_thermostat
    unless params[:id] == 'destroy_multiple'
      @thermostat = Thermostat.find(params[:id]) unless params[:id].to_i.zero?
      @rhizome = @thermostat.rhizome
    end
  end

  def set_rhizome
    # Coming from a Thermostat page
    unless params[:thermostat].nil?
      unless params[:thermostat][:rhizome].nil?
        @rhizome = Rhizome.find(params[:thermostat][:rhizome].to_i)
      end
    end

    # Coming from the Rhizome pages
    unless params[:rhizome].nil?
      @rhizome = Rhizome.find(params[:rhizome].to_i)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def thermostat_params
    p = params.require(:thermostat)
              .permit(:rhizome,
                      sensor_attributes: [:id, :onewire_id, :data_pin],
                      element_attributes: [:id, :control_pin, :power_pin])
    unless p[:rhizome].nil?
      unless p[:rhizome].is_a? Rhizome
        p[:rhizome] = Rhizome.find(p[:rhizome])
      end
    end
    p
  end

end
