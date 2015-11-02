module RhizomeInterfaces
  module Webhooks
    module JSONTemplates

      def self.included(base)
        base.extend(ClassMethods)
      end

      # == Class Methods to Include ==
      module ClassMethods

        # Converts a given Rhizome Equipment event to the associated JSON template
        # @param event [Symbol] The event to convert
        def event_to_json(event)
          {
              pump:  'pump',
              temp:  'temperature_sensor',
              heat:  'heating_element',
              therm: 'thermostat',
              rims:  'rims'
          }[event]
        end

        # Returns our current configuration for the JSON section of the Pump task webhook creation call.
        # Should probably be refactored into the database or something smart...
        def equipment_task_json
          {
              rhizome:   '{{SPARK_CORE_ID}}',
              eid:       '{{id}}',
              state:     '{{state}}',
              stop_time: '{{stop_time}}',
          }
        end

        def equipment_task_params
          [
              :event,
              :name,
              :published_at,
              :ttl
          ]
        end

        # Returns our current configuration for the JSON section of the Pump task webhook creation call.
        # Should probably be refactored into the database or something smart...
        def pump_task_json
          equipment_task_json.merge({
                                        speed: '{{speed}}'
                                    })
        end

        # Returns the param symbols for creating objects based on the
        # status message returned given our JSON template for Pump
        def pump_task_params
          equipment_task_params + pump_task_json.keys
        end

        # Returns our current configuration for the JSON section of the Temperature Sensor task webhook creation call.
        # Should probably be refactored into the database or something smart...
        def temperature_sensor_task_json
          equipment_task_json.merge({
                                        temperature:    '{{temperature}}',
                                        last_read_time: '{{last_read_time}}'
                                    })
        end

        # Returns the param symbols for creating objects based on the
        # status message returned given our JSON template for Temperature Sensor
        def temperature_sensor_task_params
          equipment_task_params + temperature_sensor_task_json.keys
        end

        # Returns our current configuration for the JSON section of the Heating Element task webhook creation call.
        # Should probably be refactored into the database or something smart...
        def heating_element_task_json
          equipment_task_json.merge({
                                        voltage: '{{voltage}}'
                                    })
        end

        # Returns the param symbols for creating objects based on the
        # status message returned given our JSON template for Temperature Sensor
        def heating_element_task_params
          equipment_task_params + temperature_sensor_task_json.keys
        end
      end
    end
  end
end