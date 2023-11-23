require 'net/http'
require 'uri'
require 'json'

# Okay, we can generate embeddings ourselves using BERT or other opensource
# NLP models. But for demo purposes lets use Open AI

class OpenAiClient
  def initialize(api_key)
    @api_key = api_key
    @base_uri = 'https://api.openai.com/v1/embeddings'
  end

  def get_embeddings(text)
    uri = URI(@base_uri)
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request['Authorization'] = "Bearer #{@api_key}"
    request.body = { model: 'text-embedding-ada-002', input: text }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)['data'].first['embedding']
    else
      raise "Error: #{response.body}"
    end
  end
end
