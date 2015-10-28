class RenameRouteIndexColumn < ActiveRecord::Migration
  def change
    rename_column :durchfahrtsorte, :index, :reihung
  end
end
