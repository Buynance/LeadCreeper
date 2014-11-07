class AddStateToBusinessesCustomer < ActiveRecord::Migration
  def change
    add_column :businesses_customers, :state, :string
  end
end
