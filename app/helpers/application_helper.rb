module ApplicationHelper
  def avatar_for user
    unless session[:avatar_url]
      session[:avatar_url] = user.avatar_url
    end
    session[:avatar_url]
  end
end
