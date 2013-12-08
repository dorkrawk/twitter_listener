require 'sequel'
require 'twitter'

$stdout.sync = true    # this exists so I'll get output from Sinatra

Twitter.configure do |config|
	config.consumer_key       = ENV["TWITTER_CONSUMER_KEY"] 
  config.consumer_secret    = ENV["TWITTER_CONSUMER_SECRET"] 
  config.oauth_token        = ENV["TWITTER_OAUTH_TOKEN"] 
  config.oauth_token_secret = ENV["TWITTER_OAUTH_TOKEN_SECRET"]
end

class Accounts

	def initialize
		bcu_db_type = ENV["BCU_DB_TYPE"]
		bcu_db_location = ENV["BCU_DB_LOCATION"]

		@bcu_db = Sequel.connect("#{bcu_db_type}://#{bcu_db_location}")
		@twitter_service_id = @bcu_db.select(:id).from(:services).filter(:name => 'Twitter').get(:id)
	end

	def get_user_ids
		user_accounts = @bcu_db.select(:account_username).from(:user_service_accounts){service_id = @twitter_service_id} # pull from Twitter db
		user_accounts.all.map { |a| Twitter.user(a[:account_username]).id unless a[:account_username].length == 0 }
	end

	def get_artists
		artist_accounts = @bcu_db.select(:account_username).from(:artist_service_accounts){service_id = @twitter_service_id} # pull from Twitter db
		artist_accounts.all.map { |a| a[:account_username].downcase unless a[:account_username].length == 0 }
	end

	def user_exists?(username)
		begin Twitter.user(username)
  		true
		rescue Twitter::Error::NotFound
  		false
  	end
	end

end