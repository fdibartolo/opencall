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
  has_and_belongs_to_many :roles
  has_many :reviews, :dependent => :delete_all
  
  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def self.from_omniauth auth
    identity = Identity.find_by(provider: auth.provider, uid: auth.uid)
    return identity.user if identity

    user = User.find_by(email: auth.info.email) if auth.info.email
    unless user
      user = User.new(
        first_name: auth.first_name_or_default,
        last_name:  auth.last_name_or_default,
        country:    'tbd',
        email:      auth.info.email,
        password:   Devise.friendly_token[0,20]
      )
    end

    user.identities.build(provider: auth.provider, uid: auth.uid, image_url: auth.info.image)
    user.save!
    user
  end

  def avatar_url
    identities.where.not(image_url: nil).pluck(:image_url).first || DefaultAvatarUrl
  end

  def admin?
    roles.where(name: RoleAdmin).exists?
  end

  def reviewer?
    roles.where(name: RoleReviewer).exists?
  end

  def add_session_vote id
    unless self.session_proposal_voted_ids.include? id
      self.session_proposal_voted_ids << id if self.session_proposal_voted_ids.count < MaxSessionProposalVotes
      save!
    end
  end

  def remove_session_vote id
    self.session_proposal_voted_ids.delete id
    save!
  end
end
