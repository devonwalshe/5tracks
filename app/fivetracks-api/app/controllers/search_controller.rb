class SearchController < ApplicationController
  
  def es_search
    s = EsSearch.new
    if params[:q]
      body = s.build_body(params)
      payload = s.search(body)
      render json: payload
    else
      render json: {errors: "no search query supplied"}
    end
  end
end
