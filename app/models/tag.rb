class Tag < ActiveRecord::Base
  has_and_belongs_to_many :session_proposals

  validates :name,  presence: true
end
