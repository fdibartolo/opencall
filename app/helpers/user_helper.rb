module UserHelper
  def validation_error_class? attribute
    validation_class? "error", attribute
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
    base_css = "form-group"
    color_css = "has-#{type} has-feedback" if resource.errors.messages.has_key?(attribute) and resource.errors.messages[attribute].any?
    "#{base_css} #{color_css}"
  end

  def validation_details? type, attribute
    return "" if resource.errors.messages[attribute].empty?
    
    translated_attribute = I18n.t("activerecord.attributes.#{resource.class.model_name.name.downcase}.#{attribute}")
    message = resource.errors.messages[attribute].map {|msg| "#{translated_attribute} #{msg}"}.join
    icon = type == "danger" ? "glyphicon-remove" : "glyphicon-warning-sign"
    html = <<-HTML
      <span class="glyphicon #{icon} form-control-feedback" aria-hidden="true"></span>
      <span class="text-#{type} small">#{message}.</span>
    HTML

    html.html_safe
  end
end