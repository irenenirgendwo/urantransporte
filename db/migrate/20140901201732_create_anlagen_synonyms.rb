class CreateAnlagenSynonyms < ActiveRecord::Migration[4.2]
  def change
    create_table :anlagen_synonyms do |t|
      t.belongs_to :anlage
      t.string :synonym
      t.timestamps
    end
  end
end
