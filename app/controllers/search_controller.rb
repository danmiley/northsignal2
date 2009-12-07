class SearchController < ApplicationController
  
  def index
    
      @search_terms = params[:s]
      @result_array = ["hi","there", "world"]
      render
  end
  
end
