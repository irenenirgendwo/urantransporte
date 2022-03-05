class AddSchiffToBeobachtung < ActiveRecord::Migration[4.2]
  def change
    add_column :beobachtungen, :schiff_id, :integer
  end
end
