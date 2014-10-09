class Firma < ActiveRecord::Base
  has_many :transportabschnitte, :dependent => :restrict_with_error
  has_many :umschlaege, :dependent => :restrict_with_error
  #belongs_to :ort
  
  def to_s 
	self.name
  end
end
