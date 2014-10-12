class Beobachtung < ActiveRecord::Base
  belongs_to :transportabschnitt
  
  validates :ankunft_zeit, presence: true
  validates :ort, presence: true
  

end
