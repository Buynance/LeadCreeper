class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.string :mobile_number

      t.timestamps
    end
  end
end
