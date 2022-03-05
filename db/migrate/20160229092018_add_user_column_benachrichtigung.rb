class AddUserColumnBenachrichtigung < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :benachrichtigung, :boolean
  end
end
