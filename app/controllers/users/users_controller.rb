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
      provider = params[:provider] == 'google_oauth2' ? 'google' : params[:provider]
      flash[:notice] = I18n.t 'flash.unlink_social_ok', provider: provider
    end

    redirect_to edit_user_registration_path(current_user)
  end

  def session_proposal_voted_ids
    render json: current_user.session_proposal_voted_ids
  end

  def toggle_session_vote
    return head(:bad_request, { message: "Missing params either id or vote" }) if params[:id].nil? or params[:vote].nil?

    if params[:vote]
      current_user.add_session_vote params[:id]
    else
      current_user.remove_session_vote params[:id]
    end
    head :ok
  end

  def session_proposal_faved_ids
    render json: current_user.session_proposal_faved_ids
  end

  def toggle_session_fav
    render json: current_user.toggle_session_faved(toggle_session_fav_params)
  end

  private
  def toggle_session_fav_params
    params.require(:id)
  end
end
