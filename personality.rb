require "sinatra"
require "sinatra/reloader" if development?
require "sinatra/content_for"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  @result = File.read("data/results.txt")
end

helpers do
  def result_text(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<pid=paragraph#{index}>#{line}</p>"
    end.join
  end

end

def valid_choice?(choice)
  choice == "A" || choice == "B"
end

def count_choice(letter)
  session.values.count(letter)
end

def title(number)
  case number
    when 1 then "You're more likely to recharge your batteries by:"
    when 2 then "You usually get more joy out of:"
    when 3 then "When you meet someone for the first time:"
    when 4 then "You would hate working with someone who's:"
    when 5 then "You're more productive when you're:"
    when 6 then "You tend to find talking to new people:"
    when 7 then "In general, which of the two are you more likely to feel:"
    when 8 then "You're more likely to recharge your batteries by:"
    when 9 then "You feel more yourself when you're:"
    when 10 then "The people who know you best are more likely to describe you as someone who's:"
  end
end

def first_choice(number)
  case number
    when 1 then "Getting some alone time"
    when 2 then "Reading a great book"
    when 3 then "You usually do most of the talking"
    when 4 then "Brash and overbearing"
    when 5 then "In a cafe"
    when 6 then "Energising"
    when 7 then "Overwhelmed and overstimulated"
    when 8 then "Going out with a group of friends"
    when 9 then "The center of attention"
    when 10 then "Outgoing and talkative"
  end
end

def second_choice(number)
  case number
    when 1 then "Going out with a group of friends"
    when 2 then "Watching a great movie"
    when 3 then "You usually do most of the listening"
    when 4 then "Timid and meek"
    when 5 then "In a quiet room"
    when 6 then "Awkward"
    when 7 then "Bored and understimulated"
    when 8 then "Getting some alone time"
    when 9 then "In the background"
    when 10 then "Quiet and reflective"
  end
end

get "/" do
  erb :home
end

get "/page/:number" do
  @number = params[:number].to_i
  erb :pages
end

get "/results" do
  erb :results
end

post "/quiz/:number" do
  @choice = params[:quiz].to_s.capitalize
  @number = params[:number].to_i

  if valid_choice?(@choice) && @number < 10
    next_page = @number + 1
    session[@number] = @choice
    redirect "/page/#{next_page}"
  elsif valid_choice?(@choice) && @number == 10 
    session[@number] = @choice
    redirect "/results"
  else
    session[:message] = "You can only enter A or B"
    status 422
    erb :pages
  end
end

