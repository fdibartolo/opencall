class Identity < ApplicationRecord
  belongs_to :user, inverse_of: :identities

  validates :provider,  presence: true
  validates :uid,       presence: true

  after_save do |identity|
    index_sessions_of(identity.user) if identity.saved_change_to_image_url? and identity.user.author?
  end

  after_destroy do |identity|
    index_sessions_of(identity.user) if identity.user.author?
  end

  def index_sessions_of user
    user.session_proposals.each { |s| s.__elasticsearch__.index_document }
  end
end
