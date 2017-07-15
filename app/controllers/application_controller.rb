class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  # Dont need this for local version
  # before_action :authenticate_user!

  # def authenticate_user!
    # unless logged_in?
      # flash[:error] = "You must be logged in to view this page."
      # redirect_to login_url
    # end
  # end

end
