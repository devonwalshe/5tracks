config = {
  host: "http://188.166.136.134:9200",
  user: 'elastic',
  password: 'alphabrodie12',
  index: '5tracks',
  transport_options: {
    request: { timeout: 5 }
  }
}

if File.exists?("config/elasticsearch.yml")
  config.merge!(YAML.load_file("config/elasticsearch.yml")[Rails.env].symbolize_keys)
end

$es = Elasticsearch::Client.new(config)