# Modul zum Twittern
#
class MeldungTwittern

  require 'twitter'
  require 'time'
  
  def initialize
    authenticate_values = Rails.application.secrets.twitter
    File.open("log/twitter.log","w"){|f| f.puts "sarte twietter"}
    #timeouts = {:write => 5, :connect => 10,:read=>30}
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = authenticate_values["consumer_key"]
      config.consumer_secret     = authenticate_values["consumer_secret"]
      config.access_token        = authenticate_values["access_token"]
      config.access_token_secret = authenticate_values["access_token_secret"]
      #config.timeouts = timeouts
    end
    
  end
  

  def twittere(beobachtung)
    twitter_meldung = "TEST #{beobachtung.verkehrstraeger}-#Urantransport gesichtet in ##{beobachtung.ort} um #{beobachtung.ankunft_zeit.strftime("%H:%M")} Uhr"
    twitter_meldung += " in Richtung #{beobachtung.fahrtrichtung}" if beobachtung.fahrtrichtung
    @client.update(twitter_meldung)
    twitter_meldung
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
