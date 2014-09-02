class Anlage < ActiveRecord::Base
  has_many :transportabschnitte
  has_many :anlagen_synonyms
end
