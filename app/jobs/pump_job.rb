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
    pump_task = {
        id: pump_id,
        state: 'on',
        stopTime: Time.now + 60,
        speed: 1
    }

    pump_args = to_particle_args(pump_task)
    logger "Sending a pumping message of: #{pump_args}"
    @particle.function :pumps, pump_args

    # # Give a little time for network lag...
    # And   I wait 5 seconds
    sleep 5

    # Then  I receive a webhook message confirming success
    # TODO: Get a way to receive webhooks...
    PumpStatus.where(
        pump_id: pump_task[:id],
        state: pump_task[:state],
        speed: pump_task[:speed],
        stopTime: pump_task[:stopTime].to_datetime
    )


    # When  I send this message to the Rhizome's Pump 1 function:
    #   | state    | off   |
    pump_args = to_particle_args(
        {
            id: pump_id,
            state: 'off'
        }
    )
    logger "Sending a pumping message of: #{pump_args}"
    @particle.function :pumps, pump_args

    # # Give a little time for network lag...
    # And   I wait 5 seconds
    sleep 5

    # Then  I receive a webhook message confirming success
    # TODO: Get a way to receive webhooks...

  end

end
