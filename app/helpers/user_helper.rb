module UserHelper
  def validation_error_class? attribute
    validation_class? "danger", attribute
  end

  def validation_error_details? attribute
    validation_details? "danger", attribute
  end

  def validation_warning_class? attribute
    validation_class? "warning", attribute
  end

  def validation_warning_details? attribute
    validation_details? "warning", attribute
  end

  private
  def validation_class? type, attribute
    base_css = "form-group row"
    color_css = "has-#{type}" if resource.errors.messages.has_key?(attribute) and resource.errors.messages[attribute].any?
    "#{base_css} #{color_css}"
  end

  def validation_details? type, attribute
    return "" if resource.errors.messages[attribute].empty?
    
    translated_attribute = I18n.t("activerecord.attributes.#{resource.class.model_name.name.downcase}.#{attribute}")
    message = resource.errors.messages[attribute].map {|msg| "#{translated_attribute} #{msg}"}.join
    icon = type == "danger" ? "fa-times" : "fa-exclamation-triangle"
    html = <<-HTML
      <span class="fa #{icon} text-#{type}" aria-hidden="true"></span>
      <span class="text-#{type} small">#{message}.</span>
    HTML

    html.html_safe
  end

  def link_context_for provider
    action, message, button_class = current_user.identities.find_by(provider: provider).nil? ? 
      [user_omniauth_authorize_path(provider), 'link me now!', 'btn-primary'] : 
      [users_unlink_social_path(provider: provider), 'already linked, unlink me', 'btn-secondary']
    
    [action, message, social_icon_for(provider), button_class]
  end

  def social_icon_for provider
    case provider
    when :google_oauth2
      'fa fa-google-plus'
    when :github
      'fa fa-github'
    when :linkedin
      'fa fa-linkedin-square'
    end
  end
end
