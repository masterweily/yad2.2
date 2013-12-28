require 'rubygems'
require 'bundler'
require 'slim'
require 'mongoid'
require 'sinatra-websocket'
require 'coffee-script'

Bundler.require
require 'sinatra/reloader' if development?

configure :development do
  register Sinatra::Reloader
  # Mongoid.configure.connect_to("yad2_spy")
  Mongoid.load!("config/mongoid.yml")
end
require './lib/scraper'
require './lib/crawler'
require './lib/model'

set :sockets, { crawlers: [] }

get '/javascripts/:filename' do
  coffee "../public/javascripts/#{params[:filename]}".to_sym
end

get '/sounds/:filename' do
  run Rack::File.new("./public/sounds/#{params[:filename]}")
end

get "/yad2/rent" do
  query = Query.fetch request.params
  redirect "/yad2/rent/query/#{query.id}"
end

get "/yad2/rent/query/:query_id" do
  @query = Query.find_by id: params[:query_id]
  slim :list
end

# json API
post "/query/:id/update" do
  content_type :json
  { success: Query.find_by(id: params[:id]).update_attributes(params[:query]) }.to_json
end

post '/yad2/query/:query_id/apartment/:apartment_id/archive' do
  content_type :json
  query = Query.find_by(id: params[:query_id])
  apartment = query.apartments.find_by(id: params[:apartment_id])
  { success: apartment.archive! }.to_json
end

post '/yad2/query/:query_id/apartment/:apartment_id/update' do
  content_type :json
  query = Query.find_by(id: params[:query_id])
  apartment = query.apartments.find_by(id: params[:apartment_id])
  { success: apartment.update_attributes(params[:apartment]), apartment: apartment }.to_json
end

get "/yad2/crawl/:query_id" do
  if request.websocket?
    query = Query.find_by id: params[:query_id]
    init_crawler_socket(query)
  else
    raise "this url serves only websockets"
  end
end

private

def init_crawler_socket(query)
  request.websocket do |ws|
    ws.onopen do
      puts 'socket opened'
      ws.send({json: :data}.to_json)
      crawler(query).start do |new_apartments|
        ws.send(new_apartments.to_json)
        new_apartments.each(&:seen!)
      end
      settings.sockets[:crawlers] << ws
    end
    ws.onmessage do |msg|
      # EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
    end
    ws.onclose do
      warn("socket closed")
      crawler(query).stop
      settings.sockets[:crawlers].delete(ws)
    end
  end
end

def crawler(query)
  Crawler.instance_for(query)
end





