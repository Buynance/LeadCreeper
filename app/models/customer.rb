require 'securerandom'
require 'twilio_lib'

class Customer < ActiveRecord::Base
	has_and_belongs_to_many :businesses
	after_create :send_signup_confirmation

	def self.send_mobile_number_error(mobile_number)
       TwilioLib.send_text(mobile_number, "Unfortunately there was an error signing you up.")
    end

    def send_signup_confirmation
       TwilioLib.send_text(self.mobile_number, "Congratulation, you have signed up to recieve greate offers.")
    end
end
