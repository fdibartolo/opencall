class OmniAuth::AuthHash
  def first_name_or_default
    return info.first_name if info.has_key? 'first_name' 
    info.name.split(' ')[0] || 'first name'
  end

  def last_name_or_default
    return info.last_name if info.has_key? 'last_name' 
    info.name.split(' ')[1] || 'last name'
  end
end
