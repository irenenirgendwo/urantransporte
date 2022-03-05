# encoding: utf-8
class AnlagenSynonym < ApplicationRecord
  belongs_to :anlage
  validates :synonym, presence: true

  def self.find_anlage_to_synonym(anlagen_name)
    anlagen_synonym = AnlagenSynonym.find_by(synonym: anlagen_name)
    anlagen_synonym.anlage
  end
  
  def self.get_all_unused_synonyms
    all_synonym_liste = AnlagenSynonym.all
    synonym_liste = []
    all_synonym_liste.each do |synonym|
      synonym_liste << synonym if synonym.anlage.nil?
    end
    synonym_liste
  end
  
end
