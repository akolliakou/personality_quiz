require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

def valid_choice?(choice)
  choice == "a" || choice == "A" || choice == "b" || choice == "B"
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

post "/recharge" do
  choice = params[:recharge]

  if valid_choice?(choice)
    session[:recharge] = choice
    redirect "/page2"
  else
    session[:message] = "You can only enter A or B"
    status 422
    erb :page1
  end
end