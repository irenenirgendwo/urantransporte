# encoding: utf-8
class Transportgenehmigung < ApplicationRecord
  has_many :transporte

  validates :lfd_nr, presence: true, uniqueness: true
end
