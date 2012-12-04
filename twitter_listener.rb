require 'tweetstream'
require_relative 'accounts'
require_relative 'events'

$stdout.sync = true    # this exists so I'll get output from Sinatra

TweetStream.configure do |config|
	config.consumer_key       = ENV["CONSUMER_KEY"] 
  config.consumer_secret    = ENV["CONSUMER_SECRET"] 
  config.oauth_token        = ENV["OAUTH_TOKEN"] 
  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
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
		puts users
		artists = @accounts.get_artists
		puts artists
		puts "about to start follow loop"
		@client.follow(users) do |status|
			puts "ok now in the twitter follow loop"
			@events.mention_artist?(status, artists)
			@events.retweet_artist?(status, artists)
			puts "now at the end of the loop, it should restart"
		end
	end


end