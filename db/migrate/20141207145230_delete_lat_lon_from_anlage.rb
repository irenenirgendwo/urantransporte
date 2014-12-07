class DeleteLatLonFromAnlage < ActiveRecord::Migration
  def change
    remove_column :anlagen, :lat
    remove_column :anlagen, :lon
  end
end
