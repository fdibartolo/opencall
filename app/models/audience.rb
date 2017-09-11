class Audience < ApplicationRecord
  validates :name,  presence: true, uniqueness: true
end
