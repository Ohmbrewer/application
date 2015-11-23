require 'rhizome_interfaces/errors/rhizome_unresponsive_error'
class AddRhizomeSproutsJob < ActiveJob::Base
  queue_as :rhizome

  # Adds all of the Rhizome's Sprouts
  # @param [Rhizome] rhizome The Rhizome to add equipment to
  # @return [TrueFalse] True if addition was successful, false if any single add failed.
  def perform(rhizome)

    Rails.logger.info '======================================='
    Rails.logger.info "Adding Sprouts to \"#{rhizome.name}\"!"
    Rails.logger.info '======================================='

    begin
      # First, add the RIMS
      rhizome.recirculating_infusion_mash_systems.each do |rims|
        unless AddSproutJob.set(queue: "#{rhizome.name}_add_rims")
                           .perform_now(rims)
          return false
        end
      end

      # Second, add the Thermostats
      rhizome.thermostats.each do |thermostat|
        if thermostat.rims.nil?
          unless AddSproutJob.set(queue: "#{rhizome.name}_add_thermostat")
                      .perform_now(thermostat)
            return false
          end
        end
      end

      # Finally, add the bare equipment
      rhizome.equipments.each do |equipment|
        if equipment.rims_id.nil? && equipment.thermostat_id.nil?
          unless AddSproutJob.set(queue: "#{rhizome.name}_add_#{equipment.type.downcase}")
                      .perform_now(equipment)
            return false
          end
        end
      end
    rescue RhizomeInterfaces::Errors::RhizomeUnresponsiveError
      Rails.logger.error '======================================='
      Rails.logger.error "Failed to add all Sprouts to \"#{rhizome.name}\"!"
      Rails.logger.error '======================================='
      return false
    end

    Rails.logger.info '======================================='
    Rails.logger.info "Finished Adding Sprouts to \"#{rhizome.name}\"!"
    Rails.logger.info '======================================='

    true
  end

end
