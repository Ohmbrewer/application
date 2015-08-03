class HooksController < ApplicationController

  # == Enabled Before Filters ==

  before_action :set_rhizome,
                only: [:new, :create]

  # Have to skip this to receive hooks from outside of Ohmbrewer.
  # Otherwise, we get CSRF token authenticity errors.
  skip_before_filter :verify_authenticity_token, only: [:pumps]

  # == Routes ==

  def new
    @particle_webhook = ParticleWebhook.new(device_id: @rhizome.particle_device.device_id)
  end

  def create
    @particle_webhook = ParticleWebhook.new(webhook_params)
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

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rhizome
    @rhizome = Rhizome.find(params[:rhizome_id]) unless params[:rhizome_id].to_i.zero?
  end

  def webhook_params
    params.require(:particle_webhook).permit(:device_id, :endpoint, :event_id, :event_type)
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
        {data: [:id, :state, :stopTime, :speed]},
        :coreid,
        :published_at,
        :ttl
    )
  end
end
