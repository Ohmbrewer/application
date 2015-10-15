class HooksController < ApplicationController

  # == Enabled Before Filters ==

  before_action :set_rhizome,
                only: [:new, :create, :index, :destroy]

  # Have to skip this to receive hooks from outside of Ohmbrewer.
  # Otherwise, we get CSRF token authenticity errors.
  skip_before_filter :verify_authenticity_token, only: [:pumps, :temps, :heat]

  # == Routes ==

  def new
    @particle_webhook = ParticleWebhook.new(device_id: @rhizome.particle_device.device_id)
  end

  def create
    # TODO: Figure out how to get this to work without the kludgy punt to destroy.
    #       For some reason, the destroy multiple (hooks#destroy) always tries to POST to create instead of destroy
    if params[:hooks].present?
      destroy
    else
      @particle_webhook = ParticleWebhook.new(hook_params)
      particle_client = Particle::Client.new(access_token: @rhizome.particle_device.access_token)
      begin
        particle_client.webhook(@particle_webhook.to_task_hash).create
      rescue => e
        logger.error "Failed to add webhook for #{@particle_webhook.event_type} #{@particle_webhook.event_id} on device #{@particle_webhook.device_id}."
        logger.error e
        flash[:danger] = 'Webhook creation failed!'
        redirect_to rhizomes_path
        return
      end

      flash[:success] = 'Webhook added!'
      redirect_to rhizomes_path
    end
  end

  def index
    particle_client = Particle::Client.new(access_token: @rhizome.particle_device.access_token)

    @particle_webhooks = associated_hooks(particle_client, @rhizome.particle_device.device_id).collect { |ph|
      et, ei = ph.event.split('/')
      ParticleWebhook.new device_id: ph.deviceID, endpoint: ph.url, event_type: et.to_sym, event_id: ei.to_i, webhook_id: ph.id
    }
  end

  def destroy
    particle_client = Particle::Client.new(access_token: @rhizome.particle_device.access_token)
    hooks = associated_hooks(particle_client, @rhizome.particle_device.device_id)

    pre = hooks.length
    post = 0
    hooks.each do |hook|
      post += 1 if hook.remove
    end

    case post
      when pre
        flash[:success] = 'Webhooks deleted'
      when 0
        flash[:danger] = 'Deletion failed!'
      else
        flash[:warning] = "Something strange happened... #{pre - post} Webhooks weren't deleted."
    end

    redirect_to rhizome_hooks_url
  end

  # == Particle Event Routes ==

  def pumps
    if pump_params['event'].present? && pump_params['event'].start_with?('pumps')

      @pump_status = PumpStatus.new pump_params
      if @pump_status.save
        render json: {
                   msg: 'Pump status logged!'
               },
               status: 200
      else
        render json: {
                   msg: 'Pump status could not be logged for some reason...'
               },
               status: 500
      end
    else
      render json: {
                 msg: 'Specified event cannot be processed at this endpoint.',
                 name: pump_params[:name]
             },
             status: 405
    end
  end

  def temps
    if temp_params['event'].present? && temp_params['event'].start_with?('temps')

      @temp_status = TemperatureSensorStatus.new temp_params
      if @temp_status.save
        render json: {
                   msg: 'Temperature Sensor status logged!'
               },
               status: 200
      else
        render json: {
                   msg: 'Temperature Sensor status could not be logged for some reason...'
               },
               status: 500
      end
    else
      render json: {
                 msg: 'Specified event cannot be processed at this endpoint.',
                 name: temp_params[:name]
             },
             status: 405
    end
  end
  def heat
    if heat_params['event'].present? && heat_params['event'].start_with?('heat')

      @heat_status = HeatingElementStatus.new heat_params
      if @heat_status.save
        render json: {
                   msg: 'Heating Element status logged!'
               },
               status: 200
      else
        render json: {
                   msg: 'Heating Element status could not be logged for some reason...'
               },
               status: 500
      end
    else
      render json: {
                 msg: 'Specified event cannot be processed at this endpoint.',
                 name: heat_params[:name]
             },
             status: 405
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rhizome
    @rhizome = Rhizome.find(params[:rhizome_id]) unless params[:rhizome_id].to_i.zero?
  end

  def hook_params
    params.require(:particle_webhook)
          .permit(:device_id, :endpoint, :event_id, :event_type, :hooks)
  end

  # Strong parameter requirements to be enforced when creating a PumpStatus
  def pump_params
    json_hash = JSON.parse(request.body.read,
                           symbolize_names: true)
    json_hash[:data] = JSON.parse(json_hash[:data],
                                  symbolize_names: true)
    json_params = ActionController::Parameters.new json_hash
    json_params.permit(
        :event,
        {data: [:id, :state, :stop_time]},
        :coreid,
        :published_at,
        :ttl
    )
  end

  # Strong parameter requirements to be enforced when creating a PumpStatus
  def temp_params
    json_hash = JSON.parse(request.body.read,
                           symbolize_names: true)
    json_hash[:data] = JSON.parse(json_hash[:data],
                                  symbolize_names: true)
    json_params = ActionController::Parameters.new json_hash
    json_params.permit(
        :event,
        {data: [:id, :state, :stop_time, :temperature, :last_read_time]},
        :coreid,
        :published_at,
        :ttl
    )
  end

  # Strong parameter requirements to be enforced when creating a PumpStatus
  def heat_params
    json_hash = JSON.parse(request.body.read,
                           symbolize_names: true)
    json_hash[:data] = JSON.parse(json_hash[:data],
                                  symbolize_names: true)
    json_params = ActionController::Parameters.new json_hash
    json_params.permit(
        :event,
        {data: [:id, :state, :stop_time]},
        :coreid,
        :published_at,
        :ttl
    )
  end

  # Gets the hooks that report as belonging to a given device
  # @param [Particle::Client] particle_client Client for interfacing with the Particle service
  # @param [String] device_id The Device ID of the device we want webhooks for
  def associated_hooks(particle_client, device_id)
    particle_client.webhooks.select { |wh| wh if (wh.deviceID == device_id) }
  end
end
