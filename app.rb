require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  # These two routes are good examples of Sinatra syntax
  # to help you with the rest of the assignment
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    # NOTE: don't change next line - it's needed by autograder!
    word = params[:word] || HangpersonGame.get_random_word
    # NOTE: don't change previous line - it's needed by autograder!

    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  # Use existing methods in HangpersonGame to process a guess.
  # If a guess is repeated, set flash[:message] to "You have already used that letter."
  # If a guess is invalid, set flash[:message] to "Invalid guess."
  post '/guess' do
    letter = params[:guess].to_s[0]
    begin
      guess_is_valid = @game.guess(letter)
      if guess_is_valid
        redirect '/show'
      else
        # If the 'guess' method returned false, then player has executed a duplicate guess
        flash[:message] = "You have already used that letter."
      end
    # Argument error implies that the guess is invalid (from hangperson_game.rb)
    rescue
      flash[:message] = "Invalid guess."
    end
    redirect '/show'
  end
  
  # Everytime a guess is made, we should eventually end up at this route.
  # Use existing methods in HangpersonGame to check if player has
  # won, lost, or neither, and take the appropriate action.
  # Notice that the show.erb template expects to use instance variables
  # @wrong_guesses and @word_with_guesses, so set those up here.
  get '/show' do
    @wrong_guesses = @game.wrong_guesses
    @word_with_guesses = @game.word_with_guesses

    game_status = @game.check_win_or_lose

    # If we have won the game...
    if game_status == :win
      redirect '/win'
    elsif game_status == :lose
      redirect '/lose'
    # We haven't won or lost, so just we want the show page
    else
      erb :show
    end
  end
  
  get '/win' do
    game_status = @game.check_win_or_lose
    if game_status == :win
      flash[:message] = "You Win!"
    else
      # Prevent cheating - redirect to /show if the game status is not :win
      redirect '/show'
    end
  end
  
  get '/lose' do
    game_status = @game.check_win_or_lose
    if game_status == :lose
      flash[:message] = "Sorry, you lose!"
    else
      # Prevent stupid people from doing stupid things - redirect to /show if game status is not :lose
      redirect '/show'
    end
  end
  
end
