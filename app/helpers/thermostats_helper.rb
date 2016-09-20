module ThermostatsHelper
  # Renders a gauge panel for a thermostat
  # @param [Thermostat] thermostat The thermostat to render
  def thermostat_gauge_panel(thermostat)
    render 'batches/gauge_panel',
           gauge: {
             title: thermostat.panel_title,
             display: thermostat,
             element: thermostat.element
           }
  end
end
