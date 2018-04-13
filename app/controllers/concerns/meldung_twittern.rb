# Modul zum Twittern
#
class MeldungTwittern

  require 'twitter'
  
  def initialize
    authenticate_values = Rails.application.secrets.twitter
    File.open("log/twitter.log","w"){|f| f.puts Rails.application.secrets.twitter}
    File.open("log/twitter.log","a"){|f| f.puts authenticate_values["consumer_key"]}
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = authenticate_values["consumer_key"]
      config.consumer_secret     = authenticate_values["consumer_secret"]
      config.access_token        = authenticate_values["access_token"]
      config.access_token_secret = authenticate_values["access_token_secret"]
    end
  end
  

    def twittere
      tweets = @client.user_timeline('rubyinside',count: 20)
      File.open("log/twitter.log","a"){|f| f.puts tweets}
    end
    
    def last_tweets anzahl
      tweet_texts = []
      tweets = @client.user_timeline('urantransport',count: anzahl)
      tweets.each do |tweet|
        tweet_texts << tweet.text
      end
      tweet_texts
    end

end
