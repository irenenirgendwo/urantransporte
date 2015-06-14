class Route < ActiveRecord::Base

  has_many :durchfahrtsorte
  
  validates :name, presence: true, uniqueness: true
  
  def orte
    self.durchfahrtsorte.map {|durch_ort| durch_ort.ort}
  end 
  
  def ordered_orte 
    sorted_durchfahrtsorte = self.durchfahrtsorte.sort{|durch_ort| durch_ort.index}
    sorted_durchfahrtsorte.map {|durch_ort| durch_ort.ort}
  end 
  
  def start_ort
    ordered_orte.first
  end 
  
  def end_ort 
    ordered_orte.last
  end 
  
end
