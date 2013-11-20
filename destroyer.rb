#!/usr/bin/env ruby

require 'date'
require 'twitter'

REQ_TOKEN_URL="https://api.twitter.com/oauth/request_token"
AUTH_URL="https://api.twitter.com/oauth/authorize"
ACCESS_TOKEN_URL="https://api.twitter.com/oauth/access_token"

# first app
CONSUMER_KEY="7IqHUKOlricIrj86PeN3g"
CONSUMER_SECRET="R0RPXCwYX84UHuXTkNgHTlIG8od848Q3eAvDHbAgOs"
ACCESS_TOKEN="2205397134-qn70xoG2nQB7Oub5IGgTlJVOnYGFqkpKmCvPGvz"
ACCESS_TOKEN_SECRET="TYrVnuRG5TY5MJmrMvIRtlphpwfLs5bQnzpdDyAwFoX8i"

# second app
ALTERNATE_CONSUMER_KEY="1pmJzZAnNKxa2BTnl3oug"
ALTERNATE_CONSUMER_SECRET="yHLeG21TjW4ixQF6q5eRz9I7zcwOP0PFAoxWEkGbs"
ALTERNATE_ACCESS_TOKEN="2205397134-Sv8bK6ZSXc9hTn3iAUZaEG9F5sltewKSmYr62no"
ALTERNATE_ACCESS_TOKEN_SECRET="5jl6OPmEWe7DxOVHOzryEXS3XuodFjVIZX5oeYsS7EjQR"

username="Whimsy Bafflegab"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

backup_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ALTERNATE_CONSUMER_KEY
  config.consumer_secret     = ALTERNATE_CONSUMER_SECRET
  config.access_token        = ALTERNATE_ACCESS_TOKEN
  config.access_token_secret = ALTERNATE_ACCESS_TOKEN_SECRET
end


timeline=client.user_timeline(username, :count => 200)
list = timeline.map(&:id)
puts "Retrieved #{list.count} tweets in user timeline."
list.each  {|i| client.status_destroy(i.to_s)  }
puts "Destroyed!"
exit 0
