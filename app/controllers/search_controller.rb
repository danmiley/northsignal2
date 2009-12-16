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
      begin
        
        # for each word, downcase and make singular, to test against standard format in db
        result = str.split.map{ |x| x.chomp.downcase.pluralize.singularize + " " }.to_s.strip unless str.blank?#intended to work for multi tokens
            logger.info 'first cleaned up version of the search string is' + result 

        # experimental spelling correction of all the subterms except for the last one, this is only for matching
        # purposes
        # the idea is that any completed words that user types in (signified by a space preceding) can be silently corrected when looking for a match
        # (if indeed there are any spelling errors)  if there is a term in progress at the end, we leave it alone, as there are too many partial
        # words that might flip to a strange word if applied to a spelling correction
        result_vector = result.split
        logger.info result_vector.length.to_s
        if result_vector.length > 1  # we only correct after one complete word, and do no attempt to correct the last ( possibly partial term)
          logger.info 'spelled up version of the search string is' + result_vector[0..(result_vector.length-2)].to_s
          result = Spellcheck.multicandidate(result_vector[0..(result_vector.length-2)].map{ |x| x + " "}.to_s) + " " + result_vector[( result_vector.length-1)]
        end
        
        logger.info 'cleaned up version of the search string is' + result 

        
    
        # something bad happened
      end
      
  
    #  result = str

    result
  end
end
