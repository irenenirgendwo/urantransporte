# encoding: utf-8
class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :admin_user,     only: [:index]

  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
    
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def edit
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = "Benutzer gelöscht"
    redirect_to users_url
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Willkommen bei der Atomtransporte-Datenbank!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def update
    if is_admin?
      if @user.update_attributes(user_params_admin)
        flash[:success] = "Einstellungen gespeichert."
        redirect_to @user
      else
        render 'edit'
      end
    else
      if @user.update_attributes(user_params)
        flash[:success] = "Einstellungen gespeichert."
        redirect_to @user
      else
        render 'edit'
      end
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def user_params_admin
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end

end
