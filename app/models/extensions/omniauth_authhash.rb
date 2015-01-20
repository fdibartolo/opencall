class OmniAuth::AuthHash
  def first_name_or_default
    return info.first_name if info.has_key? 'first_name' 
    info.name.split(' ')[0] || 'nombre'
  end

  def last_name_or_default
    return info.last_name if info.has_key? 'last_name' 
    info.name.split(' ')[1] || 'apellido'
  end
end
