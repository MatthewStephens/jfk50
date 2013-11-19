#!/usr/bin/env ruby

require 'date'
require 'twitter'
require 'rufus-scheduler'
require 'csv'


CONSUMER_KEY="MtKiWMxQiGoMkerKq9blpg"
CONSUMER_SECRET="ldBbmasgnqixO0XDoOmsRz218iMhyl3ubnvebbtxkpQ"
REQ_TOKEN_URL="https://api.twitter.com/oauth/request_token"
AUTH_URL="https://api.twitter.com/oauth/authorize"
ACCESS_TOKEN_URL="https://api.twitter.com/oauth/access_token"

ACCESS_TOKEN="2190727249-h0G0u3ZUbHRJ80qQIGekZG4mbP0bnzXhqvyGbNP"
ACCESS_TOKEN_SECRET="q11BgBbI5ixbjHzJ80VeBiCnTZUGTC6olYCyH2O2Xuvus"

$hashtags="&JFK50 &UVA"
$link_to_exhibit="buff.ly/1ho2QKh"

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONSUMER_KEY
  config.consumer_secret     = CONSUMER_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

scheduler = Rufus::Scheduler.new

start_time=Time.now
tweet_data=[]

CSV.foreach("./TeletypeForTweeting.csv", { :col_sep => "\t" }) do |row| 
  tweet_data << row.to_csv.chop
end
tweet_data.shift # remove CSV header row

def parse(row)
  one, two, three = "", "", ""
  match = row.match(/^([^,]*),([^,]*),(.*)$/)
  if ! match.nil?
    one = match[1] || ""
    two = match[2] || ""
    three = match[3] || ""
  end
  return one, two, three
end

def scheduler.handle_exception(job, exception)
    $stderr.puts "job #{job.job_id} caught exception '#{exception}'"
end

def build_chyron(timestamp, content)
  "You are following the UPI teletype as broadcast #{timestamp} November 22nd, 1963 #{$hashtags} #{$link_to_exhibit}"
end

$last_timestamp = Time.now
tweet_data[0..24].each_with_index do |datum,index|
  next if datum.length < 5
  code,timestamp,content = parse(datum)

  # header rows should be turned into tweet reminders
  if content == code
    content=build_chyron(timestamp,content) 
  end
  tweet_time = Time.parse(timestamp)
  # kluge for testing at a different time
  tweet_time = tweet_time - ((60 * 60))
  
  # see if we're already tweeting at this time
  if tweet_time > $last_timestamp
    # go ahead
    $stdout.puts "Tweet at #{tweet_time} requested.\n"
  else
    # move this up 1m, change counter
    tweet_time = tweet_time + 60
    $stdout.puts "Tweet time bumped to #{tweet_time} (+1m).\n"
    $last_timestamp = tweet_time
  end

  scheduler.at(tweet_time) do
    #Twitter.update(content)
    client.update(content)
    # could also try making a Twitter::Client and using #post('statuses/update' @content)
    report = %Q(Tweet ##{index} scheduled for #{timestamp} #{tweet_time.to_s} runtime below)
    $stdout.puts report, Time.now
  end
end

scheduler.jobs.each {|job| 
  $stdout.puts job.original
}

scheduler.at start_time do
  $stdout.puts "Starting at #{start_time}..."
end
scheduler.at '06:34:00' do
  # do something at a given point in time
  s="#{$0} it is now #{Time.now}. Starting in 2m..."
  $stdout.puts s
end

# scheduler.every '3m' do
#   # do something at a given point in time
#   s="hi Jocelyn! normal uttered at #{Time.now}"
#   system "echo #{s}"
# end

while 1 > 0 do
end
