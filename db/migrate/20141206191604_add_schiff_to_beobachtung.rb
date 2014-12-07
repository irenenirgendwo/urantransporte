class AddSchiffToBeobachtung < ActiveRecord::Migration
  def change
    add_column :beobachtungen, :schiff_id, :integer
  end
end
