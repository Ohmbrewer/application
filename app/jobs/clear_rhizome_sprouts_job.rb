require 'rhizome_interfaces/errors/rhizome_unresponsive_error'
class ClearRhizomeSproutsJob < ActiveJob::Base
  queue_as :rhizome

  # Removes all of the Rhizome's Sprouts. Unlike the AddRhizomeSproutsJob, this job shouldn't fail on an individual removal fail.
  # @param [Rhizome] rhizome The Rhizome to remove equipment to
  # @return [TrueFalse] True if removal was successful, false if any single removal failed.
  def perform(rhizome)

    Rails.logger.info '======================================='
    Rails.logger.info "Removing Sprouts from \"#{rhizome.name}\"!"
    Rails.logger.info '======================================='

    begin
      # First, remove the RIMS
      rhizome.recirculating_infusion_mash_systems.each do |rims|
        RemoveSproutJob.set(queue: "#{rhizome.name}_remove_rims")
                       .perform_now(rims)
      end

      # Second, remove the Thermostats
      rhizome.thermostats.each do |thermostat|
        if thermostat.rims.nil?
          RemoveSproutJob.set(queue: "#{rhizome.name}_remove_thermostat")
                         .perform_now(thermostat)
        end
      end

      # Finally, remove the bare equipment
      rhizome.equipments.each do |equipment|
        if equipment.rims_id.nil? && equipment.thermostat_id.nil?
          RemoveSproutJob.set(queue: "#{rhizome.name}_remove_#{equipment.type.downcase}")
                         .perform_now(equipment)
        end
      end
    rescue RhizomeInterfaces::Errors::RhizomeUnresponsiveError
      Rails.logger.error '======================================='
      Rails.logger.error "Failed to remove all Sprouts from \"#{rhizome.name}\"!"
      Rails.logger.error '======================================='
      return false # Kill the job, since we're not sure about the Rhizome's state.
    end

    Rails.logger.info '======================================='
    Rails.logger.info "Finished Removing Sprouts from \"#{rhizome.name}\"!"
    Rails.logger.info '======================================='

    true
  end

end
