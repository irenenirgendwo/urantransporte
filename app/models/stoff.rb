class Stoff < ActiveRecord::Base
  
  has_many :stoff_synonyms
  has_many :transporte
  
  validates :bezeichnung, presence: true, uniqueness: true

  def self.get_stoffe_for_selection_field
    all_stoffe = Hash.new
    Stoff.order(:bezeichnung).each do |stoff|
        all_stoffe[stoff.bezeichnung] = stoff.id
    end 
    all_stoffe
  end

  # to_string Methode für die Darstellung
  def to_s
    self.bezeichnung
  end

  def get_synonyme
    StoffSynonym.where(anlage: self)
  end

  def get_synonym_names
    get_synonyme.pluck(:synonym)
  end
  
end
