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
# Twitter.configure do |config|
#   config.consumer_key = CONSUMER_KEY
#   config.consumer_secret = CONSUMER_SECRET
#   config.oauth_token = ACCESS_TOKEN
#   config.oauth_token_secret = ACCESS_TOKEN_SECRET
# end

scheduler = Rufus::Scheduler.new

start_time=Time.now
tweet_data=[]

CSV.foreach("./TeletypeForTweeting.csv", { :col_sep => "\t" }) do |row| 
  tweet_data << row.to_csv.chop
end
tweet_data.shift # remove CSV header row

# tweet_data[0]=%q(MHR32,09:23:00,FIRST (WASHINGTON) -- THE U-S COAST GUARD IN WASHINGTON SAYS A WIDESPREAD AIR-SEA RESCUE SEARCH)
# tweet_data[1]=%q(MHR32,09:24:00,SECOND IS UNDERWAY NORTH OF CUBA FOR A PRIVATE AIRCRAFT MISSING TWO DAYS ON A FLIGHT FROM FLORIDA TO PUERTO RICO.)
# tweet_data[2]=%q(MHR32,09:25:00,THIRD U-S COAST GUARD AND NAVY PLANES FROM PUERTO RICO AND FLORIDA HAVE STEPPED UP AN AIR SEARCH BEGUN THURSDAY A SPOKESMAN SAID.)
# tweet_data[3]=%q(MHR32,09:26:00,FOURTH THE U-S AIR FORCE WAS EXPECTED TO JOIN THE SEARCH TODAY.)
# tweet_data[4]=%q(MHR32,09:27:00,FIFTH "THERE WAS NO CNDICATION GIVEN ON HOW MANY PERSONS WERE ON THE AIRCRAFT, DESCRIBED AS A SMALL CESSNA-182. ")
# tweet_data[5]=%q(MHR32,09:28:00,SIXTH THE PLANE LEFT OPA LOCA WEDNESDAY MORNING AND WAS SCHEDULED TO ARRIVE IN SAN JUAN THAT AFTERNOON.)
# tweet_data[6]=%q(MHR32,09:29:00,SEVENTH THE PILOT HAD SCHEDULED A FUELING STIP AT GREAT INAGUA BUT NEVER ARRIVED ACCORDING TO OFFICIALS ON THE BAHAMA ISLAND.)
# tweet_data[7]=%q(MHR32,09:30:00,FINAL CSA146PES11/22..)

# tweet_data[10]=%q(UPR76,09:30:00,UPR76)
# tweet_data[11]=%q(UPR76,09:31:00,MORE KENNEDY BULLETIN X X X HOSPITAL.)
# tweet_data[12]=%q(UPR76,09:32:00,"THE GOVERNOR WAS TAKEN TO THE SAME HOSPITAL. THE PRESIDENT HAD SPOKEN THIS MORNING IN FORT WORTH, THEN FLEW TO DALLAS.")
# tweet_data[13]=%q(UPR76,09:33:00,MCH KL145PES 2 HE WAS TO DELIVER A SPEECH DURING A MOTORCADE THROUGH THE CITY.)
# tweet_data[14]=%q(UPR76,09:34:00,NEWSMEN SOME FIVE CAR LENGTHS BEHIND THE PRESIDENT HEARD WHAT SOUNDED LIKE THREE BURSTS OF GUNFIRE.)
# tweet_data[15]=%q(UPR76,09:35:00,SECRET SERVICE AGENTS IN THE CAR FOLLOWING THE PRESIDENT'S QUICKLY PULLED AUTOMATIC RIFLES.)
# tweet_data[16]=%q(UPR76,09:36:00,THE BUBBLE OF THE PRESIDENT'S CAR WAS DOWN WHEN THE SHOTS RANG OUT.)
# tweet_data[17]=%q(UPR76,09:37:00,"THE PRESIDENT SLUMPED OVER IN THE BACK SEAT, FACE DOWN.")
# tweet_data[18]=%q(UPR76,09:38:00,CONNALLY LAY ON THE FLOOR OF THE REAR SEAT. WOUNDS IN THE GOVERNOR'S CHEST WERE CLEARLY VISIBLE.)
# tweet_data[19]=%q(UPR76,09:39:00,THE WOUNDS INDICATED AN AUTOMATIC WEAPON WAS USED. THREE LOUD BURSTS OF GUNFIRE WERE HEARD BEFORE THE PRESIDENT AND GOVERNOR FELL.)
# tweet_data[20]=%q(UPR76,09:40:00,"IN THE TURMOIL, IT WAS IMPOSSIBLE TO DETERMINE WHETHER SECRET SERVICE AGENTS AND DALLAS POLICE RETURNED THE FIRE.")
# tweet_data[21]=%q(UPR76,09:41:00,IT COULD NOT BE IMMEDIATELY DETERMINED EITHER WHETHER MRS. KENNEDY OR MRS. CONNALLY WERE WOUNDED.)
# tweet_data[22]=%q(UPR76,09:42:00,"BOTH WOMEN WERE IN THE CAR, AND WERE CRUSHED DOWN OVER THE INERT FORMS OF THEIR HUSBANDS AS THE BIG AUTO RACED TOWARD THE HOSPITAL.")
# tweet_data[23]=%q(UPR76,09:43:00,MRS. KENNEDY COULD BE SEEN ON THE FLOOR OF THE REAR SEAT WITH HER HEAD TOWARD THE PRESIDENT.)
# tweet_data[24]=%q(UPR76,09:44:00,HR & FK1250P11/22CST)

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
    $stdout.puts "Tweet at #{tweet_time} requested."
  else
    # move this up 1m, change counter
    tweet_time = tweet_time + 60
    $stdout.puts "Tweet time bumped to #{tweet_time} (+1m)."
    $last_timestamp = tweet_time
  end

  scheduler.at(tweet_time) do
    #Twitter.update(content)
    client.update(content)
    # could also try making a Twitter::Client and using #post('statuses/update' @content)
    report = %Q(Tweet ##{index} scheduled for #{timestamp} runtime below)
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
