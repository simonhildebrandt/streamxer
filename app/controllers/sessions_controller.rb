class SessionsController < ApplicationController
  skip_before_filter :require_logged_in, only: [:create]

  def create
    user = sync_user_from_auth_hash(auth_hash)
    login user
    if env["omniauth.params"]['mode'] == 'mobile'
      redirect_to "streamxer://#{user.id}"
    else
      redirect_to root_path
    end
  end

  def destroy
    logout
    redirect_to welcome_path
  end

  private

  def sync_user_from_auth_hash(auth_hash)
    User.find_or_create_by(uid: auth_hash.uid).tap do |user|
      user.update_attributes!(
        oauth_token_secret: auth_hash.credentials.secret,
        oauth_token: auth_hash.credentials.token
      )
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
