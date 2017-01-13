require 'singleton'

class TwitterFacade
  include ActiveModel::Validations
  include Singleton

  attr_accessor :message, :session_proposal_id
  attr_reader   :errors

  validates :message, presence: true, length: { maximum: 140 }
  validates :session_proposal_id, expire: true

  def initialize
    @errors = ActiveModel::Errors.new(self)
  end

  def update
    return false unless self.valid?
    TwitterClient.update message
  end
end
