class AddStoffIdAndQuelleToTransport < ActiveRecord::Migration
  def change
    add_column :transporte, :stoff_id, :integer
    remove_column :transporte, :stoff
    add_column :transporte, :quelle, :string
  end
end
