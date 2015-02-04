class Tag < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name [self.base_class.to_s.pluralize.underscore, Rails.env].join('_')

  has_and_belongs_to_many :session_proposals

  validates :name,  presence: true

  mapping do
    indexes :name, type: "string"
    indexes :name_suggest, type: "completion" #, payloads: true
  end

  def name_suggest
    self.name
  end

  def as_indexed_json options={}
    self.as_json(
      only: :name,
      methods: :name_suggest
    )
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
                                                body: { tags: { text: term, completion: { field: 'name_suggest' }}}
    response['tags'][0]['options'].each{|h| h.reject! {|k,v| k == "score"}}
  end
end
