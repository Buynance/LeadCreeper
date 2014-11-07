class AddStateToBusiness < ActiveRecord::Migration
  def change
    add_column :businesses, :state, :string
  end
end
