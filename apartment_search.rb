require 'rubygems'
require 'bundler'
require 'slim'
load './lib/scraper.rb'
load './lib/appartment.rb'

Bundler.require
require 'sinatra/reloader' if development?


configure :development do
  register Sinatra::Reloader
end

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
  @apartments = scraper.load_apartments
  @url = scraper.url
  Apartment.sync(@apartments)
  slim :list
end

# def get_rss(ad_type)
#   @apartments = Scraper.load_apartments(ad_type, request.params)
#   headers 'Content-Type' => 'text/xml; charset=windows-1255'
#   builder :rss
# end

# get "/yad2/rent.rss" do
#   get_rss('rent')
# end

# get "/yad2/sales.rss" do
#   get_rss('sales')
# end


