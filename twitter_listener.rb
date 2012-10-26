require 'tweetstream'
require 'sinatra'
require 'httparty'
$stdout.sync = true    # this exists so I'll get output from Sinatra


###################
# NOT IN USE FOR NOW... USING BIGCOREUS_TWITTER.RB INSTEAD
####################

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

BCU_SITE = 'http://localhost:3000'

# dorkrawk = 8315122
# bigcoreustest = 883548805

# REST is limited to 350 calls per hour

client = TweetStream::Client.new
#client = TweetStream::Daemon.new('listener')
usernames = ['bigcoreustest', 'dorkrawk']
users = usernames.collect{ |u| Twitter.user(u).id }
artists = ['americanautumn', 'bigcoreus']

puts users
puts artists

class Credit
	include HTTParty
	base_uri 'http://localhost:3000'
end

#a_post = HTTParty.post("http://httpbin.org/post")
#puts a_post

client.follow(users) do |status|
	if status.user_mentions.length > 0
		mentions = status.user_mentions.collect{ |m| m.screen_name }
		mentions.each do |m|
			if artists.include?(m.downcase)
				# now we take action because a Twitter event has happened
				puts "#{status.user.screen_name} earns X points for mentioning #{m}"
				tweet_url = "https://twitter.com/#{status.user.screen_name}/status/#{status.id_str}"
				credit = HTTParty.post("http://localhost:3000/users/add_twitter_mention_credit.json",
					:body => {"user_twittername" => "bigcoreustest", 
										"artist_twittername" => "americanautumn", 
										"event_url" => "https://twitter.com/BigCoreUsTest/status/260957049423278080"})
				puts credit
				#credit = HTTParty.post("#{BCU_SITE}/users/add_twitter_mention_credit?user_twittername=#{status.user.screen_name}&artist_twittername=#{m}&event_url=#{tweet_url}",
				#	:body => '')
				#puts credit
				# POST to bigcoreus_site
			end
		end
	end
end