class Role < ActiveRecord::Base
  has_and_belongs_to_many :users

  validates :name,  presence: true, uniqueness: true

  def self.admins_and_reviewers
    (Role.find_by(name: RoleAdmin).users + Role.find_by(name: RoleReviewer).users).uniq
  end
end
