require 'rubygems'
require 'bundler'
require 'slim'
require 'mongoid'

Bundler.require
require 'sinatra/reloader' if development?

configure :development do
  register Sinatra::Reloader
  # Mongoid.configure.connect_to("yad2_spy")
  Mongoid.load!("config/mongoid.yml")
end
require './lib/scraper'
require './lib/model'

Apartment.after_create { |apartment| puts apartment.title }

get "/yad2/rent" do
  get_list('rent')
end

get "/yad2/sales" do
  get_list('sales')
end

private

def get_list(ad_type)
  scraper = Scraper.new(ad_type, request.params)
  @query = Query.fetch scraper.url
  # @query.sync_apartments scraper.load_apartments
  slim :list
end



