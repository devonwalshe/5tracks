class EsSearch
  
  def search(body)
    results = $es.search(body: body)
    # todo - Build meta
    tracks = []
    results['hits']['hits'].each do |hit|
      st = SearchTrack.new
      st.track_id = hit["_id"].to_i
      st.score = hit["_score"]
      st.release_id = hit['_source']['release_id']
      st.artist_ids = hit['_source']['artist_ids']
      st.title = hit['_source']['song']
      st.artist_names = hit['_source']['artists']
      st.release_title = hit['_source']['release']
      tracks.append(st.to_jsonapi)
    end
    payload = {"data": tracks}
    # TODO - include pagination links
    return payload
  end
  
  def build_body(params)
    if params[:q]
      definition = Elasticsearch::DSL::Search::Search.new
      definition.query = Elasticsearch::DSL::Search::Queries::QueryString.new query: params[:q]
      if params[:offset]
        pass #TODO pagination
      end
      if params[:size]
        pass #TODO pagination 
      end
    else
      raise Error
    end
    # Return
    return definition.to_hash
  end
end
