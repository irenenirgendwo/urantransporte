class AddNextPortToSchiffe < ActiveRecord::Migration[4.2]
  def change
    add_column :schiffe, :next_ports, :text
  end
end
