class Prompt < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  before_save :update_feature_vector

  settings do
    mappings dynamic: false do
      indexes :text, type: 'text'
      indexes :feature_vector, type: 'dense_vector', dims: 1536 # We will store OpenAI generated embeddings here
    end
  end

  def self.search_vector(q)
    # fallback to usual search if openai is no available
    if $openai_client.nil?
      return search(q)
    end

    search_vector = $openai_client.get_embeddings(q)
    search({
             query: {
               script_score: {
                 query: { match_all: {} },
                 script: {
                   source: "cosineSimilarity(params.query_vector, 'feature_vector') + 1.0",
                   params: { query_vector: search_vector }
                 }
               }
             }
           })
  end

  private

  def update_feature_vector
    self.feature_vector = $openai_client.get_embeddings(self.text) unless $openai_client.nil?
  end
end
