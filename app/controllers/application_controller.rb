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
    session[:user_id] = user.id.to_s
  end

  def logout
    session.delete(:user_id)
  end

  def logged_in?
    !!current_user
  end

  def request_user_id
    session[:user_id] || request.headers['X-STREAMXER-USER']
  end

  def current_user
     request_user_id && User.where(id: request_user_id).first
  end
end
