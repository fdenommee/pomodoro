class SessionsController < ApplicationController
  def index
    if session[:user_id] != nil
      redirect_to :controller=>:pomodoros
    end
  end

	def create
    auth = request.env['rack.auth']
    unless @auth = Authorization.find_from_hash(auth)
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Authorization.create_from_hash(auth, current_user)
    end
    # Log the authorizing user in.
    self.current_user = @auth.user

    redirect_to :controller=>:pomodoros, :action=>:index
  end

  def destroy
    session[:user_id] = nil
    redirect_to sessions_url
  end
end
