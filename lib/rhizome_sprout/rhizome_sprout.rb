# == Sprout Interface methods ==
# Using this module to extend your model should allow you to interact with the Rhizome.
#
# For this to work, your model needs:
# rhizome : A reference the Rhizome you'd like to send messages to
# type : The standardized type name for the Equipment you're attaching, such as "Pump" or "RIMS"
# rhizome_eid : The Equipment ID of the Equipment instance on the Rhizome side
# rhizome_type : The Equipment Type of the Equipment instance on the Rhizome side
#
# The combination of the Rhizome and the Equipment ID represent a unique key that identifies the
# particular piece of Equipment amongst all Equipment that Ohmbrewer knows of. This information makes it fairly simple to
# determine the appropriate endpoint(s) to connect to.
module RhizomeSprout

  # Provides the expected identifier on the Rhizome's side for the Equipment
  def rhizome_eid
    NotImplementedError 'No Rhizome Equipment ID method provided!'
  end

  # Provides the expected identifier on the Rhizome's side for the Equipment Type name
  def rhizome_type_name
    NotImplementedError 'No Rhizome Equipment Type method provided!'
  end

  # Produces a String of arguments formatted in the way that the Particle Function on the Rhizome expects
  def to_args_str(current_task='', state='', stop_time='')
    "#{rhizome_eid},#{current_task},#{state},#{stop_time}"
  end

  # The name of Particle Function for updating this Equipment instance
  def update_function_name
    "#{rhizome_type_name}_#{rhizome_eid}"
  end

  # Sends the provided information to the Rhizome's appropriate Particle Function endpoint.
  def send_update(current_task='', state='', stop_time='')
    Rails.logger.info "Sending a message to the #{type} of: " <<
                      "#{to_args_str(current_task, state, stop_time)}"
    begin
      rhizome.particle_device
             .connection
             .function update_function_name,
                       to_args_str(current_task, state, stop_time)
    rescue Particle::BadRequest => e
      msg = "Lost contact with Rhizome or the Rhizome doesn't support " <<
            "the \"#{update_function_name}\" function! Check your equipment!"
      Rails.logger.error msg
    end
  end

end