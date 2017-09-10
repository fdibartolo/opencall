class Theme < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :session_proposals
end
