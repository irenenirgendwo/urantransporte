class DeleteLatLonFromAnlage < ActiveRecord::Migration[4.2]
  def change
    remove_column :anlagen, :lat
    remove_column :anlagen, :lon
  end
end
