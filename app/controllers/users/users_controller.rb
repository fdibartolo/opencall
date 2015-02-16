class Users::UsersController < ApplicationController
  before_action :authenticate_user!

  def reset_password
    raw, enc = Devise.token_generator.generate(current_user.class, :reset_password_token)

    current_user.reset_password_token   = enc
    current_user.reset_password_sent_at = Time.now.utc
    current_user.save(validate: false)

    sign_out current_user

    redirect_to edit_user_password_path(reset_password_token: raw)
  end

  def unlink_social
    identity = current_user.identities.find_by(provider: params[:provider])

    if identity
      identity.destroy
      provider = params[:provider] == :google_oauth2 ? 'google' : params[:provider]
      flash[:notice] = "Has desasociado tu cuenta de #{provider} con éxito"
    end

    redirect_to edit_user_registration_path(current_user)
  end
end
