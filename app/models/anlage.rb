# encoding: utf-8
# Atomanlagen
class Anlage < ActiveRecord::Base
  has_many :transportabschnitte
  has_many :start_transporte, :foreign_key => 'start_anlage_id', :class_name => "Transport", :dependent => :restrict_with_error
  has_many :ziel_transporte, :foreign_key => 'ziel_anlage_id', :class_name => "Transport", :dependent => :restrict_with_error
  has_many :anlagen_synonyms, :dependent => :destroy
  belongs_to :anlagen_kategorie

  validates :name, presence: true, uniqueness: true

  def self.get_anlagen_for_selection_field(kategorie = nil)
    all_anlagen = Hash.new
    anlagen = Anlage.order(:name)
    anlagen = anlagen.where(anlagen_kategorie_id: kategorie.to_i) if kategorie
    anlagen.each do |anlage|
        all_anlagen[anlage.name] = anlage.id
    end 
    all_anlagen
  end
  
  def self.get_anlagen_for_list_field(kategorie = nil)
    anlagen = Anlage.order(:name)
    anlagen = anlagen.where(anlagen_kategorie_id: kategorie.to_i) if kategorie
    anlagen
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
