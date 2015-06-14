class Route < ActiveRecord::Base

  has_many :durchfahrtsorte
  has_many :transportabschnitte
  has_many :transporte, through: :transportabschnitte
  
  validates :name, presence: true, uniqueness: true
  
  def orte
    self.durchfahrtsorte.map {|durch_ort| durch_ort.ort}
  end 
  
  def ordered_durchfahrtsorte
    self.durchfahrtsorte.order("durchfahrtsorte.index")
  end 
  
  def ordered_orte 
    self.ordered_durchfahrtsorte.map {|durch_ort| durch_ort.ort}
  end 
  
  
  def start_ort
    ordered_orte.first
  end 
  
  def end_ort 
    ordered_orte.last
  end 
  
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
  
  def erhoehe_durchfahrtsort_indizes ab_index
    d_orte = self.durchfahrtsorte.where("durchfahrtsorte.index >= ?",ab_index).order("durchfahrtsorte.index DESC")
    success = true
    d_orte.each do |durchfahrt|
      durchfahrt.index += 1
      success = success && durchfahrt.save 
    end 
    success
  end 
  
  def decrease_indizes ab_index
    d_orte = self.durchfahrtsorte.where("durchfahrtsorte.index >= ?",ab_index).order("durchfahrtsorte.index ASC")
    success = true
    d_orte.each do |durchfahrt|
      durchfahrt.index -= 1
      success = success && durchfahrt.save 
    end 
    success
  end 
  
  def tausche_durchfahrtsorte(ort_unten, ort_oben)
    index_unten = ort_unten.index 
    index_oben = ort_oben.index 
    ort_unten.index = 0
    ort_unten.save 
    ort_oben.index = index_unten 
    ort_oben.save 
    ort_unten.index = index_oben
    ort_unten.save
    return true
  end 
  
  def schiebe_hoch(durchfahrtsort)
    index_oben = durchfahrtsort.index + 1
    durchfahrtsort_oben = self.durchfahrtsorte.find_by(index: index_oben)
    if durchfahrtsort_oben.nil?
      return false
    else 
     tausche_durchfahrtsorte(durchfahrtsort, durchfahrtsort_oben)
    end 
  end 
  
  def schiebe_runter(durchfahrtsort)
    index_oben = durchfahrtsort.index-1
    durchfahrtsort_oben = self.durchfahrtsorte.find_by(index: index_oben)
    if durchfahrtsort_oben.nil?
      return false
    else 
     tausche_durchfahrtsorte(durchfahrtsort, durchfahrtsort_oben)
    end 
  end 
  
end
