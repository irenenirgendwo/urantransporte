# encoding: utf-8
class Umschlag < ApplicationRecord
  belongs_to :transport
  belongs_to :firma
  belongs_to :ort
  
end
