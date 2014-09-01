class Anlage < ActiveRecord::Base
  has_many :transportabschnitte
  belongs_to :ort
  has_many :anlagen_synonyms
end
