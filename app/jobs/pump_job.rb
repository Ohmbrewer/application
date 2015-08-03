class PumpJob < ParticleJob
  queue_as :pump

  attr_accessor :pump_id

  def initialize(*arguments)
    super
    @pump_id = arguments[:pump_id]
  end

  def perform(*args)
    raise ArgumentError, 'No pump selected!' if pump_id.nil? || pump_id.empty?

    # When  I send this message to the Rhizome's Pump 1 function:
    # | state     | on                |
    # | stop time | after 60 seconds  |
    # | speed     | 1                 |
    pump_task_1 = {
        id: pump_id,
        state: 'on',
        stop_time: Time.now + 60,
        speed: 1
    }

    pump_args = to_particle_args(pump_task_1)
    logger "Sending a pumping message of: #{pump_args}"
    @particle.function :pumps, pump_args

    # # Give a little time for network lag...
    # And   I wait 5 seconds
    sleep 5

    # Then  I receive a webhook message confirming success
    status_1 = PumpStatus.where(
        pump_id: pump_task_1[:id],
        state: pump_task_1[:state],
        speed: pump_task_1[:speed],
        stop_time: pump_task_1[:stop_time].to_datetime
    )
    logger.info "Did the first Pump Task run?: #{status_1.exists?}"


    # When  I send this message to the Rhizome's Pump 1 function:
    #   | state    | off   |
    pump_task_2 = {
      id: pump_id,
      state: 'off'
    }
    pump_args = to_particle_args(pump_task_2)
    logger "Sending a pumping message of: #{pump_args}"
    send_time = Time.now.to_datetime
    @particle.function :pumps, pump_args

    # # Give a little time for network lag...
    # And   I wait 5 seconds
    sleep 5

    check_time = Time.now.to_datetime
    # Then  I receive a webhook message confirming success
    status_2 = PumpStatus.where(
        pump_id: pump_task_2[:id],
        state: pump_task_2[:state],
        stop_time: send_time..check_time
    )
    logger.info "Did the second Pump Task run?: #{status_2.exists?}"

  end

end
