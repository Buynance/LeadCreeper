class CreateJoinTableBusinessCustomer < ActiveRecord::Migration
  def change
    create_join_table :businesses, :customers do |t|
      # t.index [:business_id, :customer_id]
      # t.index [:customer_id, :business_id]
    end
  end
end
