module PumpsHelper
  def pump_group_column(pump)
    content_tag(:td) do
      unless pump.recirculating_infusion_mash_system.nil?
        rims_link(pump.recirculating_infusion_mash_system)
      end
    end
  end
end
