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