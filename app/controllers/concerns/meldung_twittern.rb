# Modul zum Twittern
#
class MeldungTwittern

  require 'twitter'
  require 'time'
  
  def initialize
    authenticate_values = Rails.application.secrets.twitter
    File.open("log/twitter.log","w"){|f| f.puts "sarte twietter"}
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = authenticate_values["consumer_key"]
      config.consumer_secret     = authenticate_values["consumer_secret"]
      config.access_token        = authenticate_values["access_token"]
      config.access_token_secret = authenticate_values["access_token_secret"]
    end
  end
  

    def twittere
      unless Rails.env.production?
        tweets = @client.user_timeline('rubyinside',count: 20)
        File.open("log/twitter.log","a"){|f| f.puts tweets}
      end
    end
    
    def last_tweets anzahl
      tweet_texts = []
      begin
        tweets = @client.user_timeline('urantransport',count: anzahl)
        tweets.each do |tweet|
          t = DateTime.parse(tweet.created_at.to_s)
          tweet_texts << ["#{t.strftime("%d.%m.%Y - %H:%M")}- #{tweet.text}", "#{tweet.uri}"] #{tweet.uri}"# tweet.attrs
        end
      rescue => e
        File.open("log/twitter.log","w"){|f| f.puts "Fehler beim Twittern #{e}"}
        tweet_texts << ["Fehler beim Twitter-Abruf, hier alle Tweets", "https://twitter.com/urantransport"]
      end
      tweet_texts
    end

end
