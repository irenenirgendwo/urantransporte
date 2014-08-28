class Beobachtung < ActiveRecord::Base
  belongs_to :transportabschnitt
  belongs_to :ort

end
