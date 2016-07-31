module TemperatureSensorsHelper
  def temperature_sensor_group_column(temperature_sensor)
    if temperature_sensor.thermostat.nil?
      if temperature_sensor.recirculating_infusion_mash_system.nil?
        content_tag(:td)
      else
        return content_tag(:td) do
          rims_link(temperature_sensor.recirculating_infusion_mash_system)
        end
      end
    else
      return content_tag(:td) do
        if temperature_sensor.thermostat.recirculating_infusion_mash_system.nil?
          thermostat_link(temperature_sensor.thermostat)
        else
          concat thermostat_link(temperature_sensor.thermostat)
          concat rims_link(temperature_sensor.thermostat.recirculating_infusion_mash_system)
        end
      end
    end
  end

  def thermostat_link(thermostat)
    content_tag(:p) do
      link_to "Thermostat #{thermostat.rhizome_eid}", thermostat
    end
  end

  def rims_link(rims)
    content_tag(:p) do
      link_to "RIMS #{rims.rhizome_eid}", rims
    end
  end
end
