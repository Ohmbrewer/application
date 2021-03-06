module EquipmentsHelper
  def sti_equipment_type_path(type = 'equipment', equipment = nil, action = nil)
    send "#{format_sti(action, type, equipment)}_path", equipment
  end

  def format_sti(action, type, equipment)
    action || equipment ? "#{format_action(action)}#{type.underscore}" : type.underscore.pluralize.to_s
  end

  def format_action(action)
    action ? "#{action}_" : ''
  end

  def rhizome_title_reference(rhizome, action)
    if rhizome.nil?
      ''
    else
      case action
      when :add
        "to #{rhizome.name}"
      when :edit
        "on #{rhizome.name}"
      else
        ''
      end
    end
  end

  def pins_list(equipment)
    content_tag(:ul) do
      if equipment.pins.length.zero?
        content_tag(:li, 'Not Set')
      else
        equipment.pins.each do |k, v|
          concat content_tag(:li, "#{k.titlecase}: #{v}") unless v.nil?
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

  # Renders a status panel for a piece of equipment
  # @param [Equipment] equipment The equipment to render
  # @param [String] notification_level The notification level color css to use for the panel
  def status_panel(equipment, notification_level = 'primary')
    last_status = equipment.statuses.last
    render 'batches/equipment_status_panel',
           equipment: {
             title: equipment.panel_title,
             status: status_indicator_label_text(last_status),
             label: status_indicator_label_type(last_status),
             notification: notification_level
           }
  end

  # Renders a gauge panel for a piece of equipment
  # @param [Equipment] equipment The equipment to render
  def equipment_gauge_panel(equipment)
    render 'batches/gauge_panel',
           gauge: {
             title: equipment.panel_title,
             display: equipment
           }
  end
end
