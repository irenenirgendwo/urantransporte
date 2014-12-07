# encoding: utf-8
class Umschlag < ActiveRecord::Base
  belongs_to :transport
  belongs_to :firma
  belongs_to :ort
  
end
