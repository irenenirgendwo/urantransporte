class AddUserColumnBenachrichtigung < ActiveRecord::Migration
  def change
    add_column :users, :benachrichtigung, :boolean
  end
end
