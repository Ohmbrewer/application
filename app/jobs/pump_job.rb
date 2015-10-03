class PumpJob < ParticleJob
  queue_as :pump

  attr_accessor :pump_id, :task

  # Pumping tasks. Essentially, all pumps do one of these things at a time.
  # Right now they're analogous to the pump "state", but that's only because
  # we're tying the Pump Job to On/Off buttons for demos. When this job is refactored,
  # references to "tasks" should be removed and we can move the contents of #send_task into
  # the body of #perform
  SUPPORTED_TASKS = [:on, :off]

  # TODO: [After Demos] Refactor the pump job to react to commands from the Scheduler. Should make things simpler, actually
  # Sets up the PumpJob. Current handled arguments specific to this job type are:
  # * +:pump_id+ The ID of the Pump connected to the Rhizome that we wish to control
  # * +:task+ The type of Pump task we'd like to do. Currently, this is either :on or :off.
  # @param [Hash] arguments Arguments for setting up the job
  def initialize(*arguments)
    super
    Rails.logger.info "Args is: #{arguments.inspect}"
    params = pump_params(*arguments)
    @pump_id ||= params[:pump_id]
    @task ||= params[:task].to_sym
  end

  def perform(*args)
    raise ArgumentError, 'No pump selected!' if pump_id.nil? || pump_id.empty?

    if @task.present?
      case @task
        when :on
          minute_from_now = Time.now + 60
          send_task({
                        id: pump_id,
                        state: 'on',
                        stop_time: minute_from_now.to_i
                    })
        when :off
          send_task({
                        id: pump_id,
                        state: 'off'
                    })
        else
          raise ArgumentError, "Invalid PumpJob test type supplied (#{@task})! Available options are #{SUPPORTED_TASKS}"
      end
    end
  end

  private

    def send_task(task_hash)
      pump_args = self.class.to_particle_args(task_hash)
      Rails.logger.info "Sending a pumping message of: #{pump_args}"
      begin
        @particle.function :pumps, pump_args
      rescue Particle::BadRequest => e
        msg = "Lost contact with Rhizome or the Rhizome doesn't support pumping! Check your equipment!"
        Rails.logger.error msg
      end
    end

    def pump_params(*args)
      args.to_h
          .symbolize_keys
          .slice(:id, :pump_id, :task)
    end

end
