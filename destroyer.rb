#!/usr/bin/env ruby

require 'date'
require 'twitter'

CONSUMER_KEY="MtKiWMxQiGoMkerKq9blpg"
CONSUMER_SECRET="ldBbmasgnqixO0XDoOmsRz218iMhyl3ubnvebbtxkpQ"
REQ_TOKEN_URL="https://api.twitter.com/oauth/request_token"
AUTH_URL="https://api.twitter.com/oauth/authorize"
ACCESS_TOKEN_URL="https://api.twitter.com/oauth/access_token"

ACCESS_TOKEN="2190727249-h0G0u3ZUbHRJ80qQIGekZG4mbP0bnzXhqvyGbNP"
ACCESS_TOKEN_SECRET="q11BgBbI5ixbjHzJ80VeBiCnTZUGTC6olYCyH2O2Xuvus"

username="Henry H. Lightcap"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

timeline=client.user_timeline(username, :count => 200)
list = timeline.map(&:id)
puts "Retrieved #{list.count} tweets in user timeline."
list.each  {|i| client.status_destroy(i.to_s)  }
puts "Destroyed!"
exit 0
