module HeatingElementsHelper
  def heating_element_group_column(heating_element)
    if heating_element.thermostat.nil?
      content_tag(:td)
    else
      content_tag(:td) do
        if heating_element.thermostat.recirculating_infusion_mash_system.nil?
          thermostat_link(heating_element.thermostat)
        else
          concat thermostat_link(heating_element.thermostat)
          concat rims_link(heating_element.thermostat.recirculating_infusion_mash_system)
        end
      end
    end
  end
end