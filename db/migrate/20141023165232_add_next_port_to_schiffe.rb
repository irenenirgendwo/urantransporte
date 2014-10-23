class AddNextPortToSchiffe < ActiveRecord::Migration
  def change
    add_column :schiffe, :next_ports, :text
  end
end
