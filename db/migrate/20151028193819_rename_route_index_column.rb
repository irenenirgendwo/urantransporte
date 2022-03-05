class RenameRouteIndexColumn < ActiveRecord::Migration[4.2]
  def change
    rename_column :durchfahrtsorte, :index, :reihung
  end
end
