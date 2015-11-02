require 'rhizome_interfaces/webhooks/json_templates'
class HooksController < ApplicationController
  include RhizomeInterfaces::Webhooks::JSONTemplates

  # == Enabled Before Filters ==

  before_action :set_rhizome,
                only: [:new, :create, :index, :destroy]

  # Have to skip this to receive hooks from outside of Ohmbrewer.
  # Otherwise, we get CSRF token authenticity errors.
  skip_before_filter :verify_authenticity_token, only: [:pumps, :temps, :heat]

  # == Routes ==

  def new
    @particle_webhook = ParticleWebhook.new(rhizome: @rhizome)
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
        logger.error "Failed to add webhook for #{@particle_webhook.event_type} #{@particle_webhook.event_id} on #{@particle_webhook.rhizome.name}."
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
      r = Rhizome::from_device_id(ph.deviceID)
      ParticleWebhook.new rhizome: r, endpoint: ph.url, event_type: et.to_sym, event_id: ei.to_i, webhook_id: ph.id
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

  def pump
    if event_params(:pump)['event'].present? && event_params(:pump)['event'].start_with?('pump')
      @pump_status = PumpStatus.new event_params(:pump)
      handle_event(@pump_status)
    else
      handle_event_missing(event_params(:name))
    end
  end

  def temp
    if event_params(:temp)['event'].present? && event_params(:temp)['event'].start_with?('temp')
      @temp_status = TemperatureSensorStatus.new event_params(:temp)
      handle_event(@temp_status)
    else
      handle_event_missing(event_params(:name))
    end
  end

  def heat
    if event_params(:heat)['event'].present? && event_params(:heat)['event'].start_with?('heat')
      @heat_status = HeatingElementStatus.new event_params(:heat)
      handle_event(@heat_status)
    else
      handle_event_missing(event_params(:name))
    end
  end

  private

    def handle_event(status)
      if status.save
        render json: {
                   msg: "#{status.type.titlecase} logged!"
               },
               status: 200
      else
        render json: {
                   msg: "#{status.type.titlecase} could not be logged for some reason..."
               },
               status: 500
      end
    end

    def handle_event_missing(event)
      render json: {
                 msg: 'Specified event cannot be processed at this endpoint.',
                 name: event
             },
             status: 405
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_rhizome
        @rhizome = Rhizome.find(params[:rhizome_id]) unless params[:rhizome_id].to_i.zero?
        @rhizome = Rhizome.find(params[:rhizome].to_i) unless params[:rhizome].nil?
    end

    def hook_params
      p = params.require(:particle_webhook)
                .permit(:rhizome, :rhizome_id, :endpoint, :event_id, :event_type, :hooks)
      unless p[:rhizome].nil?
        unless p[:rhizome].is_a? Rhizome
          p[:rhizome] = Rhizome.find(p[:rhizome])
        end
      end
      p
    end

    def particle_json
      json_hash = JSON.parse(request.body.read,
                             symbolize_names: true)
      json_hash[:data] = JSON.parse(json_hash[:data],
                                    symbolize_names: true)
    end

    # Strong parameter requirements to be enforced when creating an EquipmentStatus
    # @param event [Symbol] The event to create a status for
    def event_params(event)
      json_params = ActionController::Parameters.new particle_json
      json_params.permit(send("#{event}_task_params"))
    end

    # Gets the hooks that report as belonging to a given device
    # @param [Particle::Client] particle_client Client for interfacing with the Particle service
    # @param [String] device_id The Device ID of the device we want webhooks for
    def associated_hooks(particle_client, device_id)
      particle_client.webhooks.select { |wh| wh if (wh.deviceID == device_id) }
    end
end
