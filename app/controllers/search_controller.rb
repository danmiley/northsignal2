class SearchController < ApplicationController
  # example search : http://northsignal2.heroku.com/search/index/foo.json?s=ipho&app=ps 
  # should yield a json payload, like this:
  # ["ipho", ["iphone 3gs"],[],[]] 
  def index
    
      @search_terms = params[:s]
      @app = params[:app]
      @result_array = ["hi","there", "world","hi","there", "world","hi","there", "world","hi","there", "world","hi","there", "world"]
      # the mapping approach below came from http://snippets.dzone.com/posts/show/3901
      @result_array = Search.all(:order => 'priority ASC', :limit => 10, :conditions => ["candidate LIKE ?", @search_terms +"%"]).map(&:candidate) # only return candidate strings
       #     @result_array = ["hi","there", "world","hi","there", "world","hi","there", "world","hi","there", "world","hi","there", "world"] 
      render
  end
  
end
