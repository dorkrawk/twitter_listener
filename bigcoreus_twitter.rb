require 'sinatra'
require 'eventmachine'
require_relative 'twitter_listener'

module BigCoreUsTwitterListener
  class App < Sinatra::Base
    $stdout.sync = true    # this exists so I'll get output from Sinatra
    $logger = Logger.new('logs/bcu_twitter.log')

    listener_researt_period = 15 * 60 # 15 minutes

    EM.run do 
    	client = TwitterListener.new
      puts ":: Starting BigCoreUs Twitter Listener ::"
      $logger.info "Starting Twitter Listener"
    	client.restart
    	$logger.info "now listening to Twitter..."

    	EM::PeriodicTimer.new(listener_researt_period) do 
    		$logger.info "Restarting Twitter Listener"
    		client.restart
    	end
    end
  end
end


