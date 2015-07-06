class JobsController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user,
                only: [:ping]

  # == Routes ==

  def ping
    flash[:success] = PingJob.new(*params).perform_now
    redirect_to configuration_url
  end

  # private
  #
  # # Strong parameter requirements to be enforced when creating a User
  # def jobs_params
  #   params.require(:user).permit(:name, :email, :password,
  #                                :password_confirmation)
  # end

end
