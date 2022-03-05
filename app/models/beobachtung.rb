# encoding: utf-8
class Beobachtung < ApplicationRecord
  belongs_to :transportabschnitt
  # Falls Schiffstransport
  belongs_to :schiff 
  belongs_to :ort
  
  validates :ankunft_zeit, presence: true
  validates :ort, presence: true
  
  def abfahrt_datum
    abfahrt_zeit.nil? ? nil : abfahrt_zeit.to_date
  end
  
  def abfahrt_uhrzeit
    abfahrt_zeit.nil? ? nil : abfahrt_zeit.to_time
  end
  
  def ankunft_datum
    ankunft_zeit.nil? ? nil : ankunft_zeit.to_date
  end
  
  def ankunft_uhrzeit
    ankunft_zeit.nil? ? nil : ankunft_zeit.to_time
  end

end
