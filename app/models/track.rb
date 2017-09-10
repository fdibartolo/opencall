class Track < ApplicationRecord
  validates :name,  presence: true, uniqueness: true
end
