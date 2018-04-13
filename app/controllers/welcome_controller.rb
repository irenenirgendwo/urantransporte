# encoding: utf-8
class WelcomeController < ApplicationController

  def index
    @transporte = Transport.order(datum: :desc).limit(7)
    twitterer = MeldungTwittern.new
    @tweets = twitterer.last_tweets(5)
  end
  
end
