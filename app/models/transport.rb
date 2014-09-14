class Transport < ActiveRecord::Base
  has_many :transportabschnitte
  belongs_to :transportgenehmigung
  has_many :versandstuecke

  belongs_to :start_anlage, :class_name => 'Anlage'
  belongs_to :ziel_anlage, :class_name => 'Anlage'	

  # Validations
  #validates :datum, presence: true
  #validates :start_anlage, presence: true
  #validates :ziel_anlage, presence: true

end
