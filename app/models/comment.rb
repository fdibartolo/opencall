class Comment < ActiveRecord::Base
  belongs_to :session_proposal
  belongs_to :user
end
