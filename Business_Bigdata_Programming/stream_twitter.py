from tweepy import Stream
from tweepy import OAuthHandler
from tweepy.streaming import StreamListener

consumer_token = 'M4mXt7xkjBKOVPCtJUrpyktIL'
consumer_seceret = 'IvxEKmI7HkoWtXRutc1DR3pkMrJ6ANcVZiHXwHtkJho7GSaZdS'
access_token = '884926443238506496-Q1hcrdOJJnNgUCDvbZRoKK8U7JTVAAf'
access_token_secret = 'ZbdupIQVx4PALDKvb2W34mk6P6bGE4xYBOkc0hNbVoOon'

tweet_stream = open('tweet_moive-stream.txt', 'a')

class Listener(StreamListener):

	def on_data(self, data):
		while(True):
			try:
				tweet_stream.write(data)
				tweet_stream.write('\n')
				return True
			except BaseException:
				pass

	def on_error(self, status):
		print(status)
		return True

	def on_timeout(self):
		print(sys.stderr)
		return True

listener = Listener()
auth = OAuthHandler(consumer_token, consumer_seceret)
auth.set_access_token(access_token, access_token_secret)
stream = Strea(auth, listener)

stream.filter(track=['Spider Man' , 'Despicable Me'])