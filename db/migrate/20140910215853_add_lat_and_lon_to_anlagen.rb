class AddLatAndLonToAnlagen < ActiveRecord::Migration
  def change
    add_column :anlagen, :lat, :float
    add_column :anlagen, :lon, :float
  end
end
