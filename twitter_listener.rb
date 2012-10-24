require 'tweetstream'
require 'sinatra'

TweetStream.configure do |config|
	config.consumer_key       = ENV["CONSUMER_KEY"] 
  config.consumer_secret    = ENV["CONSUMER_SECRET"] 
  config.oauth_token        = ENV["OAUTH_TOKEN"] 
  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
  config.auth_method        = :oauth
end

Twitter.configure do |config|
	config.consumer_key       = ENV["CONSUMER_KEY"] 
  config.consumer_secret    = ENV["CONSUMER_SECRET"] 
  config.oauth_token        = ENV["OAUTH_TOKEN"] 
  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
end

# dorkrawk = 8315122
# bigcoreustest = 883548805

# REST is limited to 350 calls per hour

client = TweetStream::Client.new
#client = TweetStream::Daemon.new('listener')
usernames = ['bigcoreustest', 'dorkrawk']
users = usernames.collect{ |u| Twitter.user(u).id }
puts "the users array is now: #{users}"
artists = ['americanautumn', 'bigcoreus']

client.follow(users) do |status|
	if status.user_mentions.length > 0
		mentions = status.user_mentions.collect{ |m| m.screen_name }
		mentions.each do |m|
			if artists.include?(m.downcase)
				puts "#{status.user.screen_name} earns X points for mentioning #{m}"
			end
		end
	end
end