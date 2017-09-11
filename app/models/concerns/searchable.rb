module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks unless Rails.env.test?

    index_name [name.pluralize.underscore, Rails.env].join('_')
    
    settings analysis: { 
      filter: {
        substring: {
          type: "nGram",
          min_gram: 3,
          max_gram: 50
        }
      },
      analyzer: {
        index_analyzer: {
          tokenizer: "keyword",
          filter: ["lowercase", "substring"]
        },
        search_analyzer: {
          tokenizer: "keyword",
          filter: ["lowercase", "substring"]
        }
      }
    }
  end
end