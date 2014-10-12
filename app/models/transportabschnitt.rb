class Transportabschnitt < ActiveRecord::Base
  #belongs_to :ort, as: :start
  #belongs_to :ort, as: :ziel
  belongs_to :transport
  belongs_to :firma
  
  def self.get_abschnitte_from_time(beobachtung_datetime)
    datum = beobachtung_datetime.to_date
    Transportabschnitt.where("start_datum <= ? and end_datum >= ? ",datum, datum)
  end

  
end
