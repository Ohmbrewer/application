class JobsController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user,
                only: [:ping] #, :dashboard]
  before_action :set_rhizome,
                only: [:ping]

  # == Routes ==

  # def dashboard
  #   @pump_statuses = PumpStatus.paginate(page: params[:page])
  # end

  def ping
    result = RhizomePingJob.new(@rhizome).perform_now

    if result[:connected]
      flash[:success] = "Pinged <strong>#{result[:name]}</strong>!<br />" <<
                        "Here's what I got:<br />" <<
                        "<pre>#{JSON.pretty_generate(result)}</pre>"
    else
      flash[:danger] = "It appears that <strong>#{result[:name]}</strong> is not connected...<br />" <<
                       "Here's what I know:<br />" <<
                       "<pre>#{JSON.pretty_generate(result)}</pre>"
    end

    redirect_to rhizomes_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rhizome
      @rhizome = Rhizome.find(params[:rhizome]) unless params[:rhizome].to_i.zero?
    end

end
