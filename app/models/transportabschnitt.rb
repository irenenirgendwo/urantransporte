# encoding: utf-8
class Transportabschnitt < ActiveRecord::Base
  belongs_to :ort, as: :start_ort_id
  belongs_to :ort, as: :ziel_ort_id
  belongs_to :transport
  belongs_to :firma
  has_many :beobachtungen
  has_many :orte, through: :strecke
  
  def self.get_abschnitte_from_time(beobachtung_datetime)
    datum = beobachtung_datetime.to_date
    Transportabschnitt.where("start_datum <= ? and end_datum >= ? ",datum, datum)
  end

  
end
