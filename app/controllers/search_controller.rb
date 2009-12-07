class SearchController < ApplicationController
  
  def index
    
      @search_terms = params[:s]
      @app = params[:app]
      @result_array = ["hi","there", "world"]
      @result_array = Search.all(:order => 'priority ASC', :limit => 10, :conditions => ["candidate LIKE ?", "%" + @search_terms +"%"]).map(&:candidate) # only return candidate strings
      render
  end
  
end
