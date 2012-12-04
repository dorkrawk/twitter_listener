require 'sinatra'
require 'eventmachine'
require_relative 'twitter_listener'

$stdout.sync = true    # this exists so I'll get output from Sinatra

listener_researt_period = 15 * 60 # 15 minutes

client = TwitterListener.new
client.restart

=begin
EM.run do 
	client = TwitterListener.new
	puts "starting Twitter listener..."
	client.restart
	puts "listening to Twitter..."

	EM::PeriodicTimer.new(listener_researt_period) do 
		puts "restarting Twitter listener"
		client.restart
	end
end=end


