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

# class TweetStream::Daemon
#   def start(path, query_parameters = {}, &block) #:nodoc:
#     # Because of a change in Ruvy 1.8.7 patchlevel 249, you cannot call anymore
#     # super inside a block. So I assign to a variable the base class method before
#     # the Daemons block begins.
#     startmethod = super.start
#     Daemons.run_proc(@app_name || 'tweetstream', :multiple => true, :no_pidfiles => true) do
#       startmethod(path, query_parameters, &block)
#     end
#   end
# end

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