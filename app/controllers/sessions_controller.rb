class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      create_session user
    else
      flash.now[:danger] = t "login_error"
      render :new
    end
  end

  def create_session user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    redirect_back_or user
  end

  def destroy
    log_out if logged_in?
    redirect_to login_path
  end
end
