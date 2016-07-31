module EquipmentsHelper

  def sti_equipment_type_path(type = 'equipment', equipment = nil, action = nil)
    send "#{format_sti(action, type, equipment)}_path", equipment
  end

  def format_sti(action, type, equipment)
    action || equipment ? "#{format_action(action)}#{type.underscore}" : "#{type.underscore.pluralize}"
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
          unless v.nil?
            concat content_tag(:li, "#{k.titlecase}: #{v}")
          end
        end
      end
    end
  end

end
