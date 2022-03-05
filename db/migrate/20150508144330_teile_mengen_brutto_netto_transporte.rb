class TeileMengenBruttoNettoTransporte < ActiveRecord::Migration[4.2]
  def change
    rename_column :transporte, :menge, :menge_netto
    add_column :transporte, :menge_brutto, :decimal
  end
end
