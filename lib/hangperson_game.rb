class HangpersonGame

  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(new_word)
  	@word = new_word
  	@guesses = ''
  	@wrong_guesses = ''
  end

  # Processes a player guess
  def guess(player_guess)
  	if player_guess.nil?
  		raise ArgumentError
  	end

  	new_guess = player_guess.downcase
  	number_of_total_guesses = @guesses.length + @wrong_guesses.length

  	# If the guess was valid (single letter)
  	if new_guess.length == 1 and letter?(new_guess)
  		# Append the guess to the right instance variable depending on if it is in our word
  		if @word.include? new_guess
  			# Don't copy guess if it's already there
  			@guesses << new_guess unless @guesses.include? new_guess
  		else
  			# Don't copy guess if it's already there
  			@wrong_guesses << new_guess unless @wrong_guesses.include? new_guess
  		end
  	else
  		raise ArgumentError
  	end

  	# Return true if a guess was not made before and false otherwise
  	return (@guesses.length + @wrong_guesses.length > number_of_total_guesses) ? true : false
  end


  # Returns a win/lose/play symbol according to game state
  def check_win_or_lose
  	# Losing situation
  	if @wrong_guesses.length >= 7 and word_with_guesses.include? '-'
  		return :lose
  	end
  	# Winning situation
  	unless word_with_guesses.include? '-'
  		return :win
  	end
  	return :play
  end


  # Substitutes correct guesses made so far into the word
  def word_with_guesses
  	displayed_word = ""
  	# For each letter in our word...
  	@word.each_byte do |b|
  		# If the letter is contained in our guesses...
  		if @guesses.include? b.chr
  			# ... then append the letter
  			displayed_word << b.chr
  		else
  			# ... otherwise append a dash
  			displayed_word << '-'
  		end
	end
  	return displayed_word
  end


  # Get a word from remote "random word" service

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  private
  	def letter?(my_letter)
  		my_letter =~ /[A-Za-z]/
  	end

end
