# encoding: utf-8
class Ort < ActiveRecord::Base
  has_many :transportabschnitte, through: :strecke 
  has_many :anlagen, :dependent => :restrict_with_error
  has_many :start_transportabschnitte, :foreign_key => 'start_ort_id', :class_name => "Transport", :dependent => :restrict_with_error
  has_many :ziel_transportabschnitte, :foreign_key => 'ziel_ort_id', :class_name => "Transport", :dependent => :restrict_with_error
  has_many :umschlaege
  
  def to_s
    name
  end
end
