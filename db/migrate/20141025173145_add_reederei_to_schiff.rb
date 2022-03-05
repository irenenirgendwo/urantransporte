class AddReedereiToSchiff < ActiveRecord::Migration[4.2]
  def change
    add_reference :schiffe, :firma, index: true
  end
end
