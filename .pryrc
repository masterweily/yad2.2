Pry.config.editor = "gvim --nofork"

# Print Ruby version at startup
Pry.config.hooks.add_hook(:when_started, :say_hi) do
  puts "Using Ruby version #{RUBY_VERSION}"
end

# Require Sinatra application
#require './apartment_search.rb'
load 'config.ru'
