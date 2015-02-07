class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(new_word)
  	@word = new_word
  	@guesses = ''
  	@wrong_guesses = ''
  end

  def guess(new_guess)
  	# If the guess was valid (single letter)
  	if new_guess.length == 1
  		# Append the guess to the right instance variable depending on if it is in our word
  		if @word.include? new_guess
  			# Don't copy guess if it's already there
  			@guesses << new_guess unless @guesses.include? new_guess
  		else
  			# Don't copy guess if it's already there
  			@wrong_guesses << new_guess unless @wrong_guesses.include? new_guess
  		end
  	end

  end

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end


end
