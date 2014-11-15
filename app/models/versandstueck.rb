# encoding: utf-8
class Versandstueck < ActiveRecord::Base
  belongs_to :transport
end
