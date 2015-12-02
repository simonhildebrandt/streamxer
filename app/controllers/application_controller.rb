class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception

  before_filter :require_logged_in

  helper_method :logged_in?, :current_user


  def require_logged_in
    redirect_to welcome_path unless logged_in?
  end

  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
  end

  def logged_in?
    !!current_user
  end

  def current_user
    session[:user_id] && User.find(session[:user_id])
  end
end
