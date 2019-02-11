class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  
  attr_accessor :word, :guesses, :wrong_guesses
  
  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''
  end
  
   def guess(char)
    if char == nil or not char =~ /^[a-zA-Z]$/i 
      raise ArgumentError 
    end
    
    # change chars to downcase
    char.downcase!


 if @word.include? char and not @guesses.include? char
      @guesses.concat char
      return true
    elsif not @word.include? char and not @wrong_guesses.include? char
      @wrong_guesses.concat char
      return true
    else
      return false
    end
  end
  
   def word_with_guesses
    result = ''
    
     @word.each_char do |char|  
      result.concat '-' unless @guesses.include? char
      result.concat char if @guesses.include? char
    end
    return result
  end
  
  def check_win_or_lose
    guess = self.word_with_guesses

 if guess == '-' or @wrong_guesses.length == 7
      :lose
    elsif guess == @word and @wrong_guesses.length < 7
      :win
    else
      :play
    end
  end
  
 

  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end
  
end
