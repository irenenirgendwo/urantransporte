class AddReedereiToSchiff < ActiveRecord::Migration
  def change
    add_reference :schiffe, :firma, index: true
  end
end
