# encoding: utf-8
class Firma < ApplicationRecord
  has_many :transportabschnitte, :dependent => :restrict_with_error
  has_many :umschlaege, :dependent => :restrict_with_error
  has_many :schiffe
  #belongs_to :ort
  
  validates :name, presence: true, uniqueness: true
  
  def to_s 
    self.name
  end
  
  def self.find_or_create_firma(firma_name, is_reederei = false)
    firma = Firma.find_by(name: firma_name)
    if firma.nil?
      firma = Firma.new(name: firma_name)
      if is_reederei
        firma.reederei = true
      end
      unless firma.save
        # Fehlerbehandlung
      end 
    end
    firma
  end
  
end
