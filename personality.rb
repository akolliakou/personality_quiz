require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/content_for'
require 'tilt/erubis'
require 'yaml'

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  @result = File.read('data/results.txt')
  @data = YAML.load_file('data/titles_questions.yaml').to_a
end

helpers do
  def result_text(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<pid=paragraph#{index}>#{line}</p>"
    end.join
  end
end

def count_choice(letter)
  session.values.count(letter)
end

get '/' do
  erb :home
end

get '/page/:number' do
  @number = params[:number].to_i
  @question = @data[@number - 1][0]
  @answer1 = @data[@number - 1][1][0]
  @answer2 = @data[@number - 1][1][1]
  erb :pages
end

get '/results' do
  erb :results
end

post '/quiz/:number' do
  @choice = params[:choice].to_s
  @number = params[:number].to_i

  if @number < 10
    next_page = @number + 1
    session[@number] = @choice
    redirect "/page/#{next_page}"
  else
    session[@number] = @choice
    redirect '/results'
  end
end
