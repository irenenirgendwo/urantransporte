# encoding: utf-8
class Transportabschnitt < ActiveRecord::Base

  belongs_to :start_ort, :class_name => 'Ort'
  belongs_to :end_ort, :class_name => 'Ort'
  belongs_to :transport
  belongs_to :firma
  belongs_to :route
  belongs_to :schiff
  has_many :beobachtungen
  # Ist das noch notwendig???
  #has_and_belongs_to_many :orte
  validate do |abschnitt| 
    RoutenValidator.new(abschnitt).validate 
  end
  
  # validiert ob Start und Endort zur Route passen, sonst darf nicht gespeichert werden.
  class RoutenValidator < ActiveModel::Validator
  
    def initialize(abschnitt)
      @abschnitt = abschnitt
    end 
    
    def validate
      if @abschnitt.route && @abschnitt.route.durchfahrtsorte.size > 1
        unless (@abschnitt.route.start_ort == @abschnitt.start_ort && @abschnitt.route.end_ort == @abschnitt.end_ort)
           @abschnitt.errors[:base] << "Start- und Endort müssen zur ausgewählten Route passen."
        end
      end
    end
    
  end
  
  def self.get_abschnitte_from_time(beobachtung_datetime)
    datum = beobachtung_datetime.to_date
    Transportabschnitt.where("start_datum <= ? and end_datum >= ? ",datum, datum)
  end
  
  def orte
    orte = []
    if self.route && self.route.durchfahrtsorte.size > 1
      self.route.durchfahrtsorte.each do |dort|
        orte << dort.ort
      end
    else
      orte << self.start_ort
      orte << self.end_ort 
    end
    self.beobachtungen.each do |beob|
      orte << beob.ort
    end
    orte.uniq
  end 

#  def faehrt_durch(ort, radius)
#    
#  end
  

 
  
end
