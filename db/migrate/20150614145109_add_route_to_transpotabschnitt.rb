class AddRouteToTranspotabschnitt < ActiveRecord::Migration[4.2]
  def change
    add_reference :transportabschnitte, :route, index: true, foreign_key: true
  end
end
