class PumpJob < ParticleJob
  queue_as :pump

  attr_accessor :pump_id

  def initialize(*arguments)
    super
    params = pump_params(*arguments)
    @pump_id = params[:pump_id]
  end

  def perform(*args)
    raise ArgumentError, 'No pump selected!' if pump_id.nil? || pump_id.empty?

    # When  I send this message to the Rhizome's Pump 1 function:
    # | state     | on                |
    # | stop time | after 60 seconds  |
    # | speed     | 1                 |
    minute_from_now = Time.now + 60
    pump_task_1 = {
        id: pump_id,
        state: 'on',
        stop_time: minute_from_now.to_i,
        speed: 1
    }

    pump_args = self.class.to_particle_args(pump_task_1)
    logger.info "Sending a pumping message of: #{pump_args}"
    begin
      @particle.function :pumps, pump_args
    rescue Particle::BadRequest => e
      msg = "Lost contact with Rhizome or the Rhizome doesn't support pumping! Check your equipment!"
      logger.error msg
      return {error: msg}
    end

    # # Give a little time for network lag...
    # And   I wait 5 seconds

    # Then  I receive a webhook message confirming success
    status_1_exists = false
    6.times do
    status_1 = PumpStatus.where(
        pump_id: pump_task_1[:id],
        state: pump_task_1[:state],
        speed: pump_task_1[:speed],
        stop_time: minute_from_now
    )
      if status_1.exists?
        status_1_exists = true
        break
      else
        sleep 10
      end
    end
    if status_1_exists
      logger.info 'First Pump Task ran'
    else
      msg = 'First Pump Task did not run!'
      logger.error msg
      return {error: msg}
    end


    # When  I send this message to the Rhizome's Pump 1 function:
    #   | state    | off   |
    pump_task_2 = {
      id: pump_id,
      state: 'off'
    }
    pump_args = self.class.to_particle_args(pump_task_2)
    logger.info "Sending a pumping message of: #{pump_args}"
    send_time = Time.now.to_datetime
    begin
      @particle.function :pumps, pump_args
    rescue Particle::BadRequest => e
      msg = "Lost contact with Rhizome or the Rhizome doesn't support pumping! Check your equipment!"
      logger.error msg
      return {error: msg}
    end

    # # Give a little time for network lag...
    # And   I wait 5 seconds
    # sleep 20

    check_time = Time.now.to_datetime
    # Then  I receive a webhook message confirming success

    status_2_exists = false
    6.times do
      status_2 = PumpStatus.where(
          pump_id: pump_task_2[:id],
          state: pump_task_2[:state],
          stop_time: send_time..check_time
      )
      if status_2.exists?
        status_2_exists = true
        break
      else
        sleep 10
      end
    end
    if status_2_exists
      logger.info 'Second Pump Task ran'
    else
      msg = 'Second Pump Task did not run!'
      logger.error msg
      return {error: msg}
    end

    success_msg = 'Pumping job ran successfully! Drink a beer!'
    logger.info success_msg
    {success: success_msg}
  end

  private

    def pump_params(*args)
      args.to_h
          .symbolize_keys
          .slice(:pump_id, :id)
    end

end
