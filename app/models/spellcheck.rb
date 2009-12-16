class Spellcheck < Object
  #this is not using activerecord as a superclass because i dont want fixtures to get picked up, and there is no db assoc'ed here
  
  # this is an initial attempt to keep spell table persistent
  # however the gentable method is run every time the controller is called
  # will need to move the class vars to memcache to have a big performance win
  # spell check is a static class, all methods are static
  @@NWORDS = nil
  @@LETTERS = nil
  
  def self.gentable
    @@NWORDS = train(words(File.read(File.join(RAILS_ROOT, 'public', "holmes.txt"))))
    @@LETTERS = ("a".."z").to_a.join
  end
  
  # takes a nominally single token string, but we dont check this presently and returns the correction
  # if we like the initial term we return it
  def self.candidate(term) 
    if @@NWORDS.nil?
  #    logger.info 'FIRED UP THE SPELL TABLE '  
        gentable() # ideally this would be a check of a memcache table init
    end
      
    newterm = correct(term)
   #  logger.info 'correcting ' + term + 'with ' + newterm
    newterm
    
  end
 
# =>   takes a string of terms and applies the corrector to each of the tokens inside
  def self.multicandidate(terms) 
    if @@NWORDS.nil?
     # logger.info 'FIRED UP THE SPELL TABLE '  
        gentable() # ideally this would be a check of a memcache table init
    end
      
    newterms = terms.split.map{ |x| candidate(x) + " " }.to_s.strip #intended to work for multi tokens
   #  logger.info 'correcting ' + terms + 'with ' + newterms
    newterms
    
  end
  
  
  def self.words text
    text.downcase.scan(/[a-z]+/)
  end

  def self.train features
    model = Hash.new(1)
    features.each {|f| model[f] += 1 }
    return model
  end

 
  def self.edits1 word
    n = word.length
    deletion = (0...n).collect {|i| word[0...i]+word[i+1..-1] }
    transposition = (0...n-1).collect {|i| word[0...i]+word[i+1,1]+word[i,1]+word[i+2..-1] }
    alteration = []
    n.times {|i| @@LETTERS.each_byte {|l| alteration << word[0...i]+l.chr+word[i+1..-1] } }
    insertion = []
    (n+1).times {|i| @@LETTERS.each_byte {|l| insertion << word[0...i]+l.chr+word[i..-1] } }
    result = deletion + transposition + alteration + insertion
    result.empty? ? nil : result
  end

  def self.known_edits2 word
    result = []
    edits1(word).each {|e1| edits1(e1).each {|e2| result << e2 if @@NWORDS.has_key?(e2) }}
    result.empty? ? nil : result
  end

  def self.known words
    result = words.find_all {|w| @@NWORDS.has_key?(w) }
    result.empty? ? nil : result
  end

  def self.correct word
    (known([word]) or known(edits1(word)) or known_edits2(word) or
      [word]).max {|a,b| @@NWORDS[a] <=> @@NWORDS[b] }
  end
end
