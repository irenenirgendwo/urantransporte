# Atomanlagen
class Anlage < ActiveRecord::Base
  has_many :transportabschnitte
  has_many :anlagen_synonyms

  def self.get_anlagen_for_selection_field
    all_anlagen = Hash.new
    Anlage.all.each do |anlage|
        all_anlagen[anlage.name] = anlage.id
    end 
    all_anlagen
  end

  # to_string Methode für die Darstellung
  def to_s
    self.name
  end

  def get_synonyme
    AnlagenSynonym.where(anlage: self)
  end

  def get_synonym_names
    get_synonyme.pluck(:synonym)
  end


end
