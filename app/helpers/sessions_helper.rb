# encoding: utf-8
module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
    @current_user
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def edit_allowed?(user_name)
    is_editor? || (logged_in? && User.find_by(name: user_name) &&  current_user.name == user_name)
  end
  
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  def store_location
    session[:forwarding_url] = request.url if request.get?
  end
  
  def is_admin?
    logged_in? && current_user.admin?
  end
  
  def is_editor?
    logged_in? && (current_user.admin? || current_user.editor?)
  end
  
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Bitte anmelden."
      redirect_to login_url
    end
  end
    
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user) || is_admin?
  end
    
  def admin_user
    redirect_to(root_url) unless is_admin?
  end
  
  def editor_user
    redirect_to(root_url) unless is_editor?
  end
  
end
