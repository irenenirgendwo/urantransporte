class AnlagenSynonym < ActiveRecord::Base
  belongs_to :anlage
  validates :synonym, presence: true

  def self.find_anlage_to_synonym(anlagen_name)
    anlagen_synonym = AnlagenSynonym.find_by(synonym: anlagen_name)
    anlagen_synonym.anlage
  end
end
