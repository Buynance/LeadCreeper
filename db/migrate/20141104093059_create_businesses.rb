class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :twilio_number
      t.string :mobile_number
      t.string :landline_number
      t.string :opt_in_code
      t.string :name

      t.timestamps
    end
  end
end
