class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, :omniauth_providers => [:linkedin]

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

    if identity
      identity.user.linkedin = auth.info.urls.public_profile if auth.provider == 'linkedin'
      identity.user.save! if auth.provider == 'linkedin'
      return identity.user
    end

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

    user.linkedin = auth.info.urls.public_profile if auth.provider == 'linkedin'
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
      self.session_proposal_voted_ids << id if allowed?(id)
      save!
    end
  end

  def remove_session_vote id
    self.session_proposal_voted_ids.delete id
    save!
  end

  def toggle_session_faved id
    if self.session_proposal_faved_ids.include? id
      self.session_proposal_faved_ids.delete id
    else
      self.session_proposal_faved_ids << id if id.is_a? Numeric
    end
    save!
  end

  def missing_bio?
    not (bio? or linkedin? or aboutme? or twitter? or facebook?)
  end

  def has_session_proposals?
    session_proposals.count > 0
  end

  private
  def allowed? id
    id.is_a? Numeric and self.session_proposal_voted_ids.count < MaxSessionProposalVotes
  end
end
