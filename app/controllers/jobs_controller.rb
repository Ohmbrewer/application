class JobsController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user,
                only: [:ping] #, :dashboard]
  before_action :set_rhizome,
                only: [:ping, :add_sprouts, :clear_sprouts]
  before_action :set_schedule,
                only: [:schedule]
  before_action :set_task,
                only: [:task]

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

  # Adds all of a Rhizome's Sprouts to the Rhizome
  def add_sprouts
    result = AddRhizomeSproutsJob.set(queue: "#{@rhizome.name}_add_sprouts")
                                 .perform_now(@rhizome)

    if result
      flash[:success] = "Flashed Sprouts to <strong>#{@rhizome.name}</strong>"
    else
      flash[:danger] = "Could not flash Sprouts to <strong>#{@rhizome.name}</strong>! Try again, but if the problem persists you should clear the Sprouts and start over."
    end

    redirect_to rhizomes_path
  end

  # Adds all of a Rhizome's Sprouts to the Rhizome
  def clear_sprouts
    result = ClearRhizomeSproutsJob.set(queue: "#{@rhizome.name}_clear_sprouts")
                                    .perform_now(@rhizome)

    if result
      flash[:success] = "Cleared Sprouts on <strong>#{@rhizome.name}</strong>"
    else
      flash[:danger] = "Could not clear Sprouts on <strong>#{@rhizome.name}</strong>!"
    end

    redirect_to rhizomes_path
  end

  # Launches a ScheduleJob if the provided Schedule is runnable.
  def schedule
    if @schedule.runnable?
      result = ScheduleJob.perform_later(@schedule)

      if result
        flash[:success] = "Starting Schedule <strong>#{@schedule.name}</strong>"
      else
        flash[:danger] = "Could not start Schedule <strong>#{@schedule.name}</strong>!"
      end

    else
      flash[:danger] = "Could not start Schedule <strong>#{@schedule.name}</strong>! " <<
                       'It needs to be fixed first. ' <<
                       'Make sure you have set a root task and that it saves with no errors.'
    end

    redirect_to schedules_path
  end

  # Launches a TaskJob.
  def task
    result = TaskJob.perform_later(@task)

    if result
      flash[:success] = "Starting Task <strong>#{@task.type} ##{@task.id}</strong>"
    else
      flash[:danger] = "Could not start Task <strong>#{@task.type} ##{@task.id}</strong>!"
    end


    redirect_to schedules_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rhizome
      @rhizome = Rhizome.find(params[:rhizome]) unless params[:rhizome].to_i.zero?
    end

    def set_schedule
      @schedule = Schedule.find(params[:schedule_id]) unless params[:schedule_id].to_i.zero?
    end

    def set_task
      @task = Task.find(params[:task_id]) unless params[:task_id].to_i.zero?
    end

end
