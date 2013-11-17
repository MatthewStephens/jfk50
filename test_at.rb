#!/usr/bin/env ruby

require 'rufus-scheduler'
scheduler = Rufus::Scheduler.new

scheduler.at '2013/11/12 11:R0500' do
  # do something at a given point in time
  s="hi Matt! special uttered at #{Time.now}"
  system "echo #{s}"
end

scheduler.every '3m' do
  # do something at a given point in time
  s="hi Jocelyn! normal uttered at #{Time.now}"
  system "echo #{s}"
end

while 1 > 0 do
end
