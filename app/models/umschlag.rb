class Umschlag < ActiveRecord::Base
  belongs_to :transport
  belongs_to :firma
  
end
