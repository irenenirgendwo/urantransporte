class Durchfahrtsort < ActiveRecord::Base

  belongs_to :ort
  belongs_to :route
  
  # Route und Ort müssen da sein, und pro Route gibt es jeden Index nur einmal
  validates :route, presence: true
  validates :reihung, presence: true, :uniqueness => {:scope => [:route]}
  validates :ort, presence: true
  
  validate do |durchfahrtsort| 
    if durchfahrtsort.route.durchfahrtsorte.size + 1 < reihung
      durchfahrtsort.errors[:base] << "Der erste Durchfahrtsort muss den Index 1 haben."
    end
  end
  
end
