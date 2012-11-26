require 'httparty'

class TweetCredit
	include HTTParty
  base_uri ENV["BCU_SITE_BASE"]
end

class Events

	def initialize
	end

	def mention_artist?(status, artists)
		if status.user_mentions.length > 0 && !status.retweeted_status
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

	def retweet_artist?(status, artists)
		if status.retweeted_status
			tweet_author = status.retweeted_status.user.screen_name
			if artists.include?(tweet_author.downcase)
				puts "#{status.user.screen_name} retweeted #{status.retweeted_status.user.screen_name}"
				retweet_url = "https://twitter.com/#{tweet_author}/status/#{status.id}"
				
				credit = TweetCredit.post("/users/add_retweet_credit.json",
									:body => {"user_twittername" => status.user.screen_name, 
														"artist_twittername" => tweet_author, 
														"event_url" => retweet_url})

					puts credit.to_s
			end
		end
	end

end
