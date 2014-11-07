require 'securerandom'
require 'twilio_lib'

class Customer < ActiveRecord::Base
	has_many :businesses_customers
	has_many :businesses, through: :businesses_customers
	
	after_create :send_signup_confirmation

	def self.send_mobile_number_error(mobile_number)
       TwilioLib.send_text(mobile_number, "Unfortunately there was an error signing you up.")
    end

    def send_signup_confirmation
       TwilioLib.send_text(self.mobile_number, "Congratulation, you have signed up to recieve great offers. To unsubcribe text the word remove to this number. ")
    end

    def self.send_subscription_confirmation(mobile_number)
    	TwilioLib.send_text(mobile_number, "Congratulation, you have signed up to recieve great offers. To unsubcribe text the word remove to this number. ")
    end
end
