require 'elasticsearch/model'

class SessionProposal < ActiveRecord::Base
  include Elasticsearch::Model

  belongs_to :user
  has_many :comments
  has_and_belongs_to_many :tags

  def as_indexed_json options={}
    self.as_json(
      only: [:id, :title, :description ],
      include: { user: { methods: [:full_name], only: [:full_name] }}
    )
  end
end
