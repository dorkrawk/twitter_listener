require 'sinatra'
require 'tweetstream'
require 'httparty'

$stdout.sync = true    # this exists so I'll get output from Sinatra

class TweetCredit
	include HTTParty
  base_uri 'http://localhost:3000'
end

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

puts "in Sinatra app"

client = TweetStream::Client.new
usernames = ['bigcoreustest', 'dorkrawk']
users = usernames.collect{ |u| Twitter.user(u).id }
puts "the users array is now: #{users}"
artists = ['americanautumn', 'bigcoreus']

client.follow(users) do |status|
	if status.user_mentions.length > 0
		mentions = status.user_mentions.collect{ |m| m.screen_name }
		mentions.each do |m|
			if artists.include?(m.downcase)
				puts "#{status.user.screen_name} tweeted about #{m}"
				tweet_url = "https://twitter.com/#{status.user.screen_name}/status/#{status.id}"

				credit = TweetCredit.post("/users/add_twitter_mention_credit.json",
								:body => {"user_twittername" => status.user.screen_name, 
													"artist_twittername" => m, 
													"event_url" => tweet_url})

				puts credit.to_s
			end
		end
	end
end

puts "should have just POSTed"
