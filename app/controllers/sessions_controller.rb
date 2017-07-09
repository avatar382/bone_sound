class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, except: [:destroy]
  layout "login"

  def new
  end

  def create
    login
    flash[:notice] = "Welcome back!"
    redirect_to accounts_url
  end

  def destroy
    logout
    flash[:notice] = "You have been successfully logged out."
    redirect_to login_url
  end
end
