class AddDestinationToSchiff < ActiveRecord::Migration
  def change
    add_column :schiffe, :current_destination, :string
    add_column :schiffe, :current_eta, :datetime
  end
end
