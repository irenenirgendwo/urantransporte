# encoding: utf-8
class Ort < ActiveRecord::Base
  has_and_belongs_to_many :transportabschnitte
  has_many :anlagen, :dependent => :restrict_with_error
  has_many :start_transportabschnitte, :foreign_key => 'start_ort_id', :class_name => "Transportabschnitt", :dependent => :restrict_with_error
  has_many :ziel_transportabschnitte, :foreign_key => 'ziel_ort_id', :class_name => "Transportabschnitt", :dependent => :restrict_with_error
  has_many :umschlaege
  
  def to_s
    name
  end
  
  def ll
    lat.to_s + ',' + lon.to_s
  end
end
