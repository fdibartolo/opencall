class Identity < ActiveRecord::Base
  belongs_to :user, inverse_of: :identities

  validates :provider,  presence: true
  validates :uid,       presence: true
end
