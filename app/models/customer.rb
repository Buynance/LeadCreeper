require 'securerandom'
require 'twilio_lib'

class Customer < ActiveRecord::Base
	has_many :businesses_customers
	has_many :businesses, through: :businesses_customers
	

	def self.send_mobile_number_error(mobile_number)
       TwilioLib.send_text(mobile_number, "Unfortunately there was an error signing you up.")
    end

    def self.send_subscription_confirmation(customer_mobile_number, business_mobile_number)
    	TwilioLib.send_text(customer_mobile_number, "Congratulation, you have signed up to recieve great offers. To unsubcribe text the word remove to this number. ", business_mobile_number)
    end
end
