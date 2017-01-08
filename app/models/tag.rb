class Tag < ActiveRecord::Base
  include Searchable

  has_and_belongs_to_many :session_proposals

  validates :name, presence: true

  mapping do
    indexes :name, type: "completion" #, payloads: true
  end

  def as_indexed_json options={}
    self.as_json(only: :name)
  end

  def self.search_all
    query = Jbuilder.encode do |json|
      json.query do
        json.match_all Hash.new
      end
    end

    search query
  end

  def self.suggest term
    response = __elasticsearch__.client.suggest index: index_name, 
                                                body: { tags: { text: term, completion: { field: 'name' }}}
    response['tags'][0]['options'].each{|h| h.reject! {|k,v| k == "score"}}
  end
end
