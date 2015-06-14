class Durchfahrtsort < ActiveRecord::Base

  belongs_to :ort
  belongs_to :route
  
  # Route und Ort müssen da sein, und pro Route gibt es jeden Index nur einmal
  validates :route, presence: true
  validates :index, presence: true, :uniqueness => {:scope => [:route]}
  validates :ort, presence: true

  
end
