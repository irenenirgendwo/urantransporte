class AddRouteToTranspotabschnitt < ActiveRecord::Migration
  def change
    add_reference :transportabschnitte, :route, index: true, foreign_key: true
  end
end
