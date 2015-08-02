class HooksController < ApplicationController

  # Have to skip this to receive hooks from outside of Ohmbrewer.
  # Otherwise, we get CSRF token authenticity errors.
  skip_before_filter :verify_authenticity_token

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
