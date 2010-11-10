class PomodorosController < ApplicationController
  before_filter :require_login, :except=>[:new]

  def index
    @pomodoros = Pomodoro.find_all_by_user_id(current_user)
  end

  def new
    if current_user == nil
      @remaining_time = Pomodoro.pomodoro_time_in_millis
      return
    end
    @pomodoro = Pomodoro.active_pomodoro(current_user)
    @running_pomodoro_detected = @pomodoro != nil

    if(@pomodoro == nil)
      @pomodoro = Pomodoro.new
      @pomodoro.user = current_user
      @pomodoro.start_time = Time.now
      @pomodoro.save
    end

    @remaining_time = @pomodoro.remaining_time_in_millis
  end

  def close
    pomodoro = Pomodoro.active_pomodoro(current_user)
    pomodoro.finished = true unless pomodoro == nil
    pomodoro.success = true
    pomodoro.save
    redirect_to :new_pomodoro
  end

private
  def require_login
    unless signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to sessions_url # halts request cycle
    end
  end
end
