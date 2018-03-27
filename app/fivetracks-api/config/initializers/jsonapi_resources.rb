JSONAPI.configure do |config|
  # built in paginators are :none, :offset, :paged
  config.default_paginator = :paged
  config.default_page_size = 10
  config.maximum_page_size = 20
  config.top_level_meta_include_record_count = true
  config.top_level_meta_record_count_key = :total
  config.top_level_meta_include_page_count = true
  config.top_level_meta_page_count_key = :pages
end