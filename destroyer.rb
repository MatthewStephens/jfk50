#!/usr/bin/env ruby

require 'date'
require 'twitter'

REQ_TOKEN_URL="https://api.twitter.com/oauth/request_token"
AUTH_URL="https://api.twitter.com/oauth/authorize"
ACCESS_TOKEN_URL="https://api.twitter.com/oauth/access_token"

# first app
CONSUMER_KEY="LwmgdHnaGllQShOVG0fQA"
CONSUMER_SECRET="HUMx3ysLeqRKkuHR6Pk5TCJdq7Jm5V8NN3db8nQzLg"
ACCESS_TOKEN="2207254310-gsfAp1t51mnNVwLDTFguBqUuKeiYgGtARxoas0b"
ACCESS_TOKEN_SECRET="WVULbmKoP9bZOJ6lTe6hfMngEnsBF1Ech0Rp62LcGPZ2w"


username="Something Will Fail"

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
