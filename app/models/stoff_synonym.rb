# encoding: utf-8
class StoffSynonym < ActiveRecord::Base

  belongs_to :stoff
  validates :synonym, presence: true

  def self.find_stoff_to_synonym(name)
    synonym = StoffSynonym.find_by(synonym: name)
    synonym.stoff
  end
  
  def self.get_all_unused_synonyms
    all_synonym_liste = StoffSynonym.all
    synonym_liste = []
    all_synonym_liste.each do |synonym|
      synonym_liste << synonym if synonym.stoff.nil?
    end
    synonym_liste
  end
  
end
