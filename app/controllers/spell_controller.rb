class SpellController < ApplicationController
  def index
    
      @search_terms = params[:s]
      @app = params[:app]

     # @search_terms = Spellcheck.candidate(@search_terms)  # this line is a fine result for single term querys, but breaks with multi token strings


      @search_terms = Spellcheck.multicandidate(@search_terms)
      # the mapping approach below came from http://snippets.dzone.com/posts/show/3901
         render
  end
end
