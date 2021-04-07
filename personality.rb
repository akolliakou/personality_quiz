require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  
end

def valid_choice?(choice)
  choice.capitalize ==  "A" || choice.capitalize == "B"
end

get "/" do
  erb :home
end

get "/page/:number" do
  number_string = params[:number].to_s
  page_symbol = "page#{number_string}".to_sym
  erb page_symbol
end

post "/recharge/:number" do
  choice = params[:recharge]
  number = params[:number].to_s.to_i # we chain to_i on to_s because symbol class doesn't have to_i instance method
  puts "test test #{number}"
  if valid_choice?(choice) && number < 10
    next_page = number + 1
    session[:recharge] = choice
    redirect "/page/#{next_page}"
  elsif valid_choice?(choice) && number > 10 #the last question-page will redirect to the results page
    session[:recharge] = choice
    redirect "/results"
  else
    session[:message] = "You can only enter A or B"
    status 422
    erb :page1
  end
end

