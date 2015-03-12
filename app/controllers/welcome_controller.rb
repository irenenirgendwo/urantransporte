# encoding: utf-8
class WelcomeController < ApplicationController
  def index
    @transporte = Transport.order(datum: :desc).limit(7)
  end
end
