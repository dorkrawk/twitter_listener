require './bigcoreus_twitter'

set :environment, :development
enable :logging

run BigCoreUsTwitterListener::App