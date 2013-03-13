# Twitter Listener

This is a Sinatra app using the [TweetStream](https://github.com/intridea/tweetstream) gem to continuously listen for interactive Twitter events by a set of users on another set of users.  This was built for a spectific project for listening to fan interactions with bands but could easily be generalized to other such interactor/interactee events.

It's set to periodically repull Twitter usernames from a remote database so that the events stay up to date with a dynamic system.

*Note: Some naming conventions of this project still coincide with it's original purpose, a project called BigCoreUs, so at this time you may find 'bcu' or 'bigcoreus' references throughout the code.*