module EquipmentStatusesHelper
  # Determines label text for equipment status indicators
  # @param [EquipmentStatus] status The equipment status to display text for
  # @return [String] The label text
  def status_indicator_label_text(status)
    if status.nil?
      'NO DATA'
    else
      case status.state
      when 'ON', 'on'
        'ON'
      when 'OFF', 'off'
        'OFF'
      else
        'NO DATA'
      end
    end
  end

  # Determines label (type) color for equipment status indicators
  # @param [EquipmentStatus] status The equipment status to display css for
  # @return [String] The label css
  def status_indicator_label_type(status)
    if status.nil?
      'default'
    else
      case status.state
      when 'ON', 'on'
        'success'
      when 'OFF', 'off'
        'danger'
      else
        'default'
      end
    end
  end
end
