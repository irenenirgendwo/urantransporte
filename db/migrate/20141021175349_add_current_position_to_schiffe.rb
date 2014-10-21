class AddCurrentPositionToSchiffe < ActiveRecord::Migration
  def change
    add_column :schiffe, :current_lat, :float
    add_column :schiffe, :current_lon, :float
  end
end
