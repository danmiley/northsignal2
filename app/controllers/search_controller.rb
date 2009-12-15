class SearchController < ApplicationController
  # example search : http://northsignal2.heroku.com/search/index/foo.json?s=ipho&app=ps 
  # should yield a json payload, like this:
  # ["ipho", ["iphone 3gs"],[],[]] 
  def index

    @search_terms = params[:s]
    @app = params[:app]


    @clean_search_terms  = clean_up(@search_terms)

    @result_array = ["hi","there", "world","hi","there", "world","hi","there", "world","hi","there", "world","hi","there", "world"]
    # the mapping approach below came from http://snippets.dzone.com/posts/show/3901
    @result_array = Search.all(:order => 'priority ASC', :limit => 10, :conditions => ["candidate LIKE ?", @clean_search_terms +"%"]).map(&:candidate_label) # only return candidate strings
    #     @result_array = ["hi","there", "world","hi","there", "world","hi","there", "world","hi","there", "world","hi","there", "world"] 
    render
  end


  def clean_up(str)
    # normalize case, chomp, and singularize
    result = ''

    if !str.blank?

      result = str.split.map{ |x| x.chomp.downcase.pluralize.singularize + " " }.to_s.strip #intended to work for multi tokens
    end
        logger.info 'cleaned up version of the search string is' + result 
    

    #  result = str

    result
  end
end
