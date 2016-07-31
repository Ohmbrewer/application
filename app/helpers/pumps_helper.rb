module PumpsHelper
  def pump_group_column(pump)
    content_tag(:td) do
      unless pump.recirculating_infusion_mash_system.nil?
        rims_link(pump.recirculating_infusion_mash_system)
      end
    end
  end

  def rims_link(rims)
    content_tag(:p) do
      link_to "RIMS #{rims.rhizome_eid}", rims
    end
  end
end
