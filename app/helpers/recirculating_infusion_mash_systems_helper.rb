module RecirculatingInfusionMashSystemsHelper
  # Renders a gauge panel for a RIMS
  # @param [RecirculatingInfusionMashSystems] rims The RIMS to render
  def rims_gauge_panel(rims)
    render 'batches/gauge_panel',
           gauge: {
             title: rims.panel_title,
             display: rims,
             element: rims.tube.element,
             recirculation_pump: rims.recirculation_pump
           }
  end
end
