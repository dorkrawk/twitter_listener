require 'tweetstream'
require_relative 'accounts'
require_relative 'events'

module BigCoreUsTwitterListener

	TweetStream.configure do |config|
		config.consumer_key       = ENV["TWITTER_CONSUMER_KEY"] 
	  config.consumer_secret    = ENV["TWITTER_CONSUMER_SECRET"] 
	  config.oauth_token        = ENV["TWITTER_OAUTH_TOKEN"] 
	  config.oauth_token_secret = ENV["TWITTER_OAUTH_TOKEN_SECRET"]
	  config.auth_method        = :oauth
	end

	class TwitterListener

		def initialize
			@client = TweetStream::Client.new
			@accounts = Accounts.new
			@events = Events.new
		end

		def restart
			@client.stop_stream
			users = @accounts.get_user_ids
			artists = @accounts.get_artists
			$logger.info "now listening to #{users.length} users and #{artists.length} artists"
			@client.follow(users) do |status|
				@events.artist_mention(status, artists)
				@events.artist_retweet(status, artists)
			end
		end

	end
end