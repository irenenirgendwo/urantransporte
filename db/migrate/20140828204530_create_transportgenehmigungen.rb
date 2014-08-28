class CreateTransportgenehmigungen < ActiveRecord::Migration
  def change
    create_table :transportgenehmigungen do |t|

      t.timestamps
    end
  end
end
