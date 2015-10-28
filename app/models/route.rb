class Route < ActiveRecord::Base

  has_many :durchfahrtsorte
  has_many :transportabschnitte
  has_many :transporte, through: :transportabschnitte
  
  validates :name, presence: true, uniqueness: true
  
  def orte
    self.durchfahrtsorte.map {|durch_ort| durch_ort.ort}
  end 
  
  def ordered_durchfahrtsorte
    self.durchfahrtsorte.order("durchfahrtsorte.reihung")
  end 
  
  def ordered_orte 
    self.ordered_durchfahrtsorte.map {|durch_ort| durch_ort.ort}
  end 
  
  # fuer die Ortsanzeige
  #
  def includes_ort? ort_id
    self.durchfahrtsorte.map{|durch_ort| durch_ort.ort.id}.include?(ort_id)
  end 
  
  
  def start_ort
    ordered_orte.first
  end 
  
  def end_ort 
    ordered_orte.last
  end 
  
  # Fuer die Kartenanzeige in der Transport-Darstellung die Ausgabe der abgefahrenen Strecke
  #
  def get_strecken
    strecken = []
    begin_ort = self.ordered_durchfahrtsorte.first 
    next_ort = begin_ort
    self.ordered_durchfahrtsorte.each do |durchfahrt|
      unless durchfahrt == begin_ort
        strecken << [next_ort.ort, durchfahrt.ort]
      end
      next_ort = durchfahrt
    end 
    strecken
  end 
  
  # Methode zum Verschieben eines Durchfahrtsortes in der Reihenfolge
  #
  def schiebe_hoch(durchfahrtsort)
    reihung_oben = durchfahrtsort.reihung - 1
    durchfahrtsort_oben = self.durchfahrtsorte.find_by(reihung: reihung_oben)
    if durchfahrtsort_oben.nil?
      return false
    else 
     tausche_durchfahrtsorte(durchfahrtsort, durchfahrtsort_oben)
    end 
  end 
  
  # Methode zum Verschieben eines Durchfahrtsortes in der Reihenfolge
  #
  def schiebe_runter(durchfahrtsort)
    reihung_oben = durchfahrtsort.reihung + 1
    durchfahrtsort_oben = self.durchfahrtsorte.find_by(reihung: reihung_oben)
    if durchfahrtsort_oben.nil?
      return false
    else 
     tausche_durchfahrtsorte(durchfahrtsort, durchfahrtsort_oben)
    end 
  end 

  # Methoden zum Einfuegen eines neuen Durchfahrtsortes an der richtigen Stelle
  #
  def erhoehe_durchfahrtsort_indizes ab_reihung
    return false if ab_reihung.nil?
    #d_orte = Durchfahrtsort.where("durchfahrtsorte.route_id = ? AND durchfahrtsorte.reihung > ?", self.id, ab_reihung -1).order("durchfahrtsorte.reihung DESC")
    d_orte = self.durchfahrtsorte.where("durchfahrtsorte.reihung >= ?",ab_reihung).order("durchfahrtsorte.reihung DESC")
    success = true
    d_orte.each do |durchfahrt|
      durchfahrt.reihung += 1
      success = success && durchfahrt.save 
    end 
    success
  end 
  
  # Methode zum Loeschen eines neuen Durchfahrtsorts und Anpassung der bisherigen Reihung.
  #
  def decrease_indizes ab_reihung
    d_orte = self.durchfahrtsorte.where("durchfahrtsorte.reihung >= ?",ab_reihung).order("durchfahrtsorte.reihung ASC")
    success = true
    d_orte.each do |durchfahrt|
      durchfahrt.reihung -= 1
      success = success && durchfahrt.save 
    end 
    success
  end 
  
  private
  
    # Hilsmethode zum Rauf- und runterschieben
    #
    def tausche_durchfahrtsorte(ort_unten, ort_oben)
      reihung_unten = ort_unten.reihung 
      reihung_oben = ort_oben.reihung 
      ort_unten.reihung = 0
      ort_unten.save 
      ort_oben.reihung = reihung_unten 
      ort_oben.save 
      ort_unten.reihung = reihung_oben
      ort_unten.save
      return true
    end
    
end
