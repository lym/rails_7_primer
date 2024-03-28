module SessionsHelper

  # Returns the currently logged in user, if any
  def current_user
    session_user_id = session[:user_id]
    if session_user_id
      @current_user ||= User.find_by(id: session_user_id)
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs in a user
  def log_in(user)
    session[:user_id] = user.id
  end

  # Logs out the current user
  def log_out
    reset_session
    @current_user = nil
  end
end
