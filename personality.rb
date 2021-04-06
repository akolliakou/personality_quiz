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

get "/page1" do
  erb :page1
end

get "/page2" do
  erb :page2
end

get "/page3" do
  erb :page3
end

get "/page4" do
  erb :page4
end

get "/page5" do
  erb :page5
end

get "/page6" do
  erb :page6
end

get "/page7" do
  erb :page7
end

get "/page8" do
  erb :page8
end

get "/page9" do
  erb :page9
end

get "/page10" do
  erb :page10
end

post "/recharge/:number" do
  choice = params[:recharge]
  number = params[:number].to_s.to_i # we chain to_i on to_s because symbol class doesn't have to_i instance method
  puts "test test #{number}"
  if valid_choice?(choice) && number < 10
    next_page = number + 1
    session[:recharge] = choice
    redirect "/page#{next_page}"
  elsif valid_choice?(choice) && number > 10 #the last question-page will redirect to the results page
    session[:recharge] = choice
    redirect "/results"
  else
    session[:message] = "You can only enter A or B"
    status 422
    erb :page1
  end
end

