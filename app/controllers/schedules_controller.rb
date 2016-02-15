class SchedulesController < ApplicationController

  # == Enabled Before Filters ==

  before_action :logged_in_user
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  def index
    @schedules = Schedule.non_batch_records.paginate(page: params[:page])
  end

  def show
    if params[:id] == 'destroy_multiple'
      destroy_multiple
    end
  end

  def duplicate
    if params[:schedule_id].nil?
      flash[:danger] = 'Could not duplicate Schedule. No Schedule identified!'
      redirect_to schedules_path
    elsif Schedule.find(params[:schedule_id].to_i).root_task.nil?
        flash[:danger] = 'Could not duplicate Schedule. No Root Task specified!'
        redirect_to schedules_path
    else
      old_schedule = Schedule.find(params[:schedule_id].to_i)
      @schedule = old_schedule.deep_dup

      msg = "Duplicated <strong>#{old_schedule.name}</strong>."

      if @schedule.save(validate: false)
        # We'll assume that validation has passed before duplication.
        flash[:success] = msg
        redirect_to schedules_path
      else
        flash[:warning] = "Tried to duplicate #{@schedule.name}, but something went wrong!"
        render 'new'
      end
    end
  end

  def new
    if EquipmentProfile.all.length.zero?
      flash[:warning] = 'You may not create a Schedule until you have defined at least one Equipment Profile.'
      redirect_to schedules_path
    end
    msg = 'For now, you need to know the Task ID of the Task ' <<
          'you would like each task to follow. ' <<
          'You must save the Schedule first before each Task is assigned an ID.'
    flash.now[:info] = msg
    @schedule = params[:schedule].nil? ? Schedule.new : Schedule.new(schedule_params)
  end

  def edit
    msg = 'For now, you need to know the Task ID of the Task ' <<
        'you would like each task to follow. ' <<
        'You must save the Schedule first before each Task is assigned an ID.'
    flash.now[:info] = msg
  end

  def create
    @schedule = Schedule.new(schedule_params)

    if @schedule.valid?
      msg = view_context.add_schedule_message(@schedule)
      if @schedule.save
        flash[:success] = msg
        redirect_to schedules_path
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def update
    if @schedule.update(schedule_params)
      flash[:success] = view_context.update_schedule_message(@schedule)
      redirect_to schedules_path
    else
      render 'edit'
    end
  end

  def destroy
    if params[:id] != 'destroy_multiple'
      msg = view_context.delete_schedule_message(@schedule)
      @schedule.destroy
      flash[:success] = msg
      redirect_to schedules_path
    else
      destroy_multiple
    end
  end

  def destroy_multiple
    pre = Schedule.where(id: params[:schedules])
    Schedule.destroy_all(id: params[:schedules])
    post = pre.where(id: params[:schedules])

    case post.length
      when 0
        flash[:success] = view_context.delete_multiple_schedule_success_message
      when pre.length
        flash[:danger] = view_context.delete_multiple_schedule_fail_message
      else
        flash[:warning] = view_context.delete_multiple_schedule_mix_message(pre.length, post.length)
    end

    redirect_to schedules_url
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_schedule
      unless params[:id] == 'destroy_multiple'
        @schedule = Schedule.find(params[:id]) unless params[:id].to_i.zero?
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def schedule_params
      params.require(:schedule)
            .permit(:name,
                    :root_task_id,
                    tasks_attributes: [:id, :type, :sprout, :equipment, :duration, :trigger,
                                       :target_temperature, :ramp_estimate, :parent_id, :_destroy])
    end
  
end
