# encoding: utf-8
class Beobachtung < ActiveRecord::Base
  belongs_to :transportabschnitt
  # Falls Schiffstransport
  belongs_to :schiff 
  belongs_to :ort
  
  validates :ankunft_zeit, presence: true
  validates :ort, presence: true
  

end
