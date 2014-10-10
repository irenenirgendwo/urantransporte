class AnlagenKategorie < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  has_many :anlagen

  def self.get_kategorien_for_selection_field
    all_anlagen_kategorien = Hash.new
    AnlagenKategorie.all.each do |kategorie|
        all_anlagen_kategorien[kategorie.name] = kategorie.id
    end 
    all_anlagen_kategorien
  end
  
  # to_string Methode für die Darstellung
  def to_s
    self.name
  end

end
