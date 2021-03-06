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
  
 
  post '/guess' do
    letter = params[:guess].to_s[0]
    ### YOUR CODE HERE ###
    result = nil
    begin
    result = @game.guess(letter)
    rescue ArgumentError => e
      flash[:message] = "Invalid guess."
    end
    if !result.nil? and !result
      flash[:message] = "You have already used that letter."
    end
    redirect '/show'
  end
  
 get '/show' do
    win_or_lose = @game.check_win_or_lose
    
    redirect '/win'if win_or_lose == :win
    redirect '/lose'if win_or_lose == :lose
    erb :show # You may change/remove this line
  end
  
  get '/win' do
    # If the user tries to access the /win page, he/she is redirected to the /show page
    redirect '/show' if not @game.check_win_or_lose == :win
    erb :win # You may change/remove this line
  end
  
  get '/lose' do
    # If the user tries to access the /lose page, he/she is redirected to the /show page
    redirect '/show' if not @game.check_win_or_lose == :lose
    erb :lose # You may change/remove this line
  end
end

