require 'sequel'
require 'twitter'

class Accounts
	db_type = ENV["DB_TYPE"]
	db_location = ENV["DB_LOCATION"]

	@@db = Sequel.connect("#{db_type}://#{db_location}")
	@twitter_service_id = @@db.select(:id).from(:services).filter(:name => 'Twitter').get(:id)

	Twitter.configure do |config|
		config.consumer_key       = ENV["CONSUMER_KEY"] 
	  config.consumer_secret    = ENV["CONSUMER_SECRET"] 
	  config.oauth_token        = ENV["OAUTH_TOKEN"] 
	  config.oauth_token_secret = ENV["OAUTH_TOKEN_SECRET"]
	end

	def get_user_ids
		user_accounts = @@db.select(:account_username).from(:user_service_accounts){service_id = @twitter_service_id}
		user_accounts.all.map { |a| Twitter.user(a[:account_username]).id if user_exists?(a[:account_username]) }
	end

	def get_artists
		artist_accounts = @@db.select(:account_username).from(:artist_service_accounts){service_id = @twitter_service_id}
		artist_accounts.all.map { |a| a[:account_username] if user_exists?(a[:account_username]) }
	end

	def user_exists?(username)
		begin Twitter.user(username)
  		true
		rescue Twitter::Error::NotFound
  		false
  	end
	end

end