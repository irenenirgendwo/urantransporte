class Transportabschnitt < ActiveRecord::Base
  #belongs_to :ort, as: :start
  #belongs_to :ort, as: :ziel
  belongs_to :transport
  belongs_to :firma

  
end
