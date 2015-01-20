class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:github, :google_oauth2, :linkedin]

  validates :first_name,  presence: true
  validates :last_name,   presence: true
  validates :country,     presence: true

  has_many :session_proposals
  has_many :identities, :dependent => :delete_all

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.from_omniauth auth
    identity = Identity.find_by(provider: auth.provider, uid: auth.uid)
    return identity.user if identity

    user = User.find_by(email: auth.info.email) if auth.info.email
    unless user
      first, last = auth.info.name.split(' ') 
      user = User.new(
        first_name: first  || 'mi nombre',
        last_name:  last || 'mi apellido',
        country:    'pais',
        email:      auth.info.email,
        password:   Devise.friendly_token[0,20]
      )
    end

    user.identities.build(provider: auth.provider, uid: auth.uid)
    user.save!
    user
  end
end
