class BusinessesCustomer < ActiveRecord::Base
	belongs_to  :business
	belongs_to :customer

	state_machine :state, :initial => :subscribed do

      event :unsubscribe do
        transition [:subscribed] => :unsubscribed
      end

      event :subscribe do
        transition [:unsubscribed] => :subscribed
      end

  end
end