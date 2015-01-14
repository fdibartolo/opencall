class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:github]

  validates :first_name,  presence: true
  validates :last_name,   presence: true
  validates :country,     presence: true

  has_many :session_proposals
  has_many :identities, :dependent => :delete_all

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.from_omniauth auth
    joins(:identities).where("identities.provider = ? and identities.uid = ?", auth.provider, auth.uid).first_or_create do |user|
      first, last = auth.info.name.split(' ') 
      user.first_name = first  || 'whoami'
      user.last_name  = last || 'whoami'
      user.country    = '??'
      user.email      = auth.info.email
      user.password   = Devise.friendly_token[0,20]
      Identity.create!(provider: auth.provider, uid: auth.uid, user: user) if user.save!
    end
  end
end
