class Transport < ActiveRecord::Base
  has_many :transportabschnitte
  belongs_to :transportgenehmigung
  has_many :versandstuecke

end
