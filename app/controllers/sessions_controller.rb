class SessionsController < ApplicationController
  skip_before_filter :require_logged_in, only: [:create]

  def create
    Rails.logger.debug auth_hash
    login sync_user_from_auth_hash(auth_hash)
    redirect_to root_path
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
        oauth_token_secret: auth_hash.credentials.token
      )
    end
  end

  def auth_hash
    request.env['omniauth.auth']
  end
end
