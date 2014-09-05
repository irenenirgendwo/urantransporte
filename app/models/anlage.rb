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

end
