module SessionsHelper
  def login
    session[:user_id] = 1
  end

  def logout
    session.delete(:user_id)
  end

  def current_user
    @current_user ||= session[:user_id]
  end

  def logged_in?
    !session[:user_id].nil?
  end
end
