class TeileMengenBruttoNettoTransporte < ActiveRecord::Migration
  def change
    rename_column :transporte, :menge, :menge_netto
    add_column :transporte, :menge_brutto, :decimal
  end
end
