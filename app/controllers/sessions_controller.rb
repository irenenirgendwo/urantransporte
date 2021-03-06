# encoding: utf-8
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by "email = ? OR name = ?", params[:session][:email].downcase, params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = 'Falscher Benutzername oder Passwort.'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
