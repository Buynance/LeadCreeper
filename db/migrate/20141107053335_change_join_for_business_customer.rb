class ChangeJoinForBusinessCustomer < ActiveRecord::Migration
  def change
  	add_column :businesses_customers, :id, :primary_key
  end
end
