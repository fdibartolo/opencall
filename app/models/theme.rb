class Theme < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :session_proposals
end
