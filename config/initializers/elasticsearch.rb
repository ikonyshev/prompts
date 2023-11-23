Elasticsearch::Model.client = Elasticsearch::Client.new url: ENV.fetch("FOUNDELASTICSEARCH_URL"), log: true
