class Route < ActiveRecord::Base

  has_many :durchfahrtsorte
  
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
  
  
end
