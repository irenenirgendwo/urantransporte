class AddLatAndLonToAnlagen < ActiveRecord::Migration[4.2]
  def change
    add_column :anlagen, :lat, :float
    add_column :anlagen, :lon, :float
  end
end
