class JobsController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user,
                only: [:ping]

  # == Routes ==

  def ping
    result = PingJob.new(*params).perform_now

    if result['connected']
      flash[:success] = "Pinged <strong>#{result['name']}</strong>!<br />Here's what I got:<br /><pre>#{JSON.pretty_generate(result)}</pre>"
    else
      flash[:danger] = "It appears that <strong>#{result['name']}</strong> is not connected...<br />Here's what I know:<br /><pre>#{JSON.pretty_generate(result)}</pre>"
    end

    redirect_to rhizomes_url
  end

  # private
  #
  # # Strong parameter requirements to be enforced when creating a User
  # def jobs_params
  #   params.require(:user).permit(:name, :email, :password,
  #                                :password_confirmation)
  # end

end
