class EquipmentStatus < ActiveRecord::Base
  belongs_to :equipment,
             inverse_of: :equipment_statuses
  belongs_to :task

  # == States ==
  # The Equipment State on the Rhizome. Either ON or OFF or unknown
  enum state: [:unknown, :off, :on]

  # == Task Scopes ==
  scope :created_before, ->(time) { where('created_at < ?', time) }
  scope :created_after, ->(time) { where('created_at > ?', time) }
  scope :updated_before, ->(time) { where('updated_at < ?', time) }
  scope :updated_after, ->(time) { where('updated_at > ?', time) }

  # == Subclass Scopes ==
  # These scopes make so anything that references EquipmentStatus generally
  # may also reference each of these subclasses specifically, automagically.
  scope :pump_statuses, -> { where(type: 'PumpStatus') }
  scope :heating_element_statuses, -> { where(type: 'HeatingElementStatus') }
  scope :temperature_sensor_statuses, -> { where(type: 'TemperatureSensorStatus') }

  # == Serializers ==
  # HashSerializer provides a way to convert the JSONB contents
  # of the :data column into a Hash object
  serialize :data, HashSerializer

  # == Validations ==
  validates :state, presence: true

  # == SSE Triggers ==
  after_save   :notify_state_change
  after_create :notify_state_change

  # == Instance Methods ==

  # Quick check for if this is simply an EquipmentStatus or one of its subclasses
  def is_basic_equipment_status?
    type == 'EquipmentStatus'
  end

  # Initializer that parses input from
  def initialize(attributes = nil, options = {})
    super self.class.parse_incoming_status(attributes), options
  end

  def to_state_json
    JSON.generate(state: state)
  end

  def to_sse_json
    JSON.generate({
                    rhizome_name: equipment.rhizome.name,
                    equipment_id: equipment.id,
                    state:        state,
                    stop_time:    stop_time
                  })
  end

  # == Class Methods ==
  class << self
    # == STI Helpers ==

    # The list of supported Equipment Status types
    # @todo Move this out into a table of available Equipment Status Types
    def equipment_status_types
      %w(PumpStatus HeatingElementStatus TemperatureSensorStatus)
    end

    # == Particle Webhook Methods ==

    # Identifies which Equipment subclass should be used with this Status subclass
    # @abstract EquipmentStatus subclasses must override this to function
    def equipment_class
      Equipment
    end

    def convert_state(state)
      if state == '--' || state.nil?
        :unknown
      else
        state.downcase.to_sym
      end
    end

    def convert_time(time)
      Time.at(time.to_i).to_datetime
    end

    # Parses the Status reported by our Particle webhook
    # @param [Hash] params A Hash or Hash-like object that contains parameters supplied by the Particle JSON webhook
    # @return [Hash] A parsed parameter Hash for producing a PumpStatus
    def parse_incoming_status(params)
      r = Rhizome::from_device_id(params[:rhizome])
      raise ArgumentError,
            'Rhizome not found. Bad Rhizome Device ID.' if r.nil?

      e = equipment_class.find_by_rhizome_eid(r, params[:eid])
      raise ArgumentError,
            'Equipment not found. Bad Rhizome Equipment ID or the Sprout was not found on the Rhizome.' if e.nil?

      {
          state:        convert_state(params[:state]),
          stop_time:    convert_time(params[:stop_time].to_i),
          equipment_id: e.id,
          task:         Task.find(params[:current_task])
      }
    end

    # == SSE Methods ==

    # Listens for a change in the EquipmentStatus table and reports the incoming rows
    def on_change
      EquipmentStatus.connection.execute "LISTEN #{EquipmentStatus.table_name}"
      loop do
        EquipmentStatus.connection.raw_connection.wait_for_notify do |event, pid, equipment_status|
          yield equipment_status
        end
      end
    ensure
      EquipmentStatus.connection.execute "UNLISTEN #{EquipmentStatus.table_name}"
    end

    # Default event channel for broadcasting SSE's
    def event_channel
      {event: 'equipment_status_update'}
    end
  end

  private

    # == SSE Methods ==

    # Notifies any listeners that there has been a state change on the EquipmentStatus table
    # @abstract EquipmentStatus subclasses must override this to function
    def notify_state_change
      EquipmentStatus.connection.execute "NOTIFY #{EquipmentStatus.table_name}, '#{to_sse_json}'"
    end
end
