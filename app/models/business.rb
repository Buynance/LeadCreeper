require 'securerandom'
require 'twilio_lib'

class Business < ActiveRecord::Base
	before_create :parse_landline_number, :create_opt_in_code

  has_and_belongs_to_many :customers

	state_machine :state, :initial => :awaiting_confirmation do

      after_transition :on => :passed_confirmation do |business, t|
      	business.create_twilio_number
        business.send_business_signup_acceptance
      end

      event :passed_confirmation do
        transition [:awaiting_confirmation] => :accepted
      end

      event :reject do
        transition [:awaiting_confirmation, :accepted] => :rejected
      end

  end

  def send_mass_sms_to_customers(message)
    self.customers.each do |customer|
       TwilioLib.send_text(customer.mobile_number, message, self.twilio_number)
    end
  end
  
	def parse_landline_number     
		phone_number_object = GlobalPhone.parse(self.landline_number)
		phone_number_object = nil if (phone_number_object != nil and phone_number_object.territory.name != "US")
		if phone_number_object.nil? or self.phone_number.length < 10
		  self.mobile_number = nil
		else
		  self.mobile_number = phone_number_object.international_string
		end
  end

    def self.send_business_found_sms(mobile_number)
    	 TwilioLib.send_text(mobile_number, "You have already signed up to this service.")
    end

    def self.send_customer_found_sms(mobile_number)
       TwilioLib.send_text(mobile_number, "You have already signed up to get messages from this business.")
    end

    def self.search_by_mobile_number(mobile_number)
      Business.where(state: "accepted").find_by(mobile_number: GlobalPhone.parse(mobile_number).international_string)
    end


    def self.send_landline_parsing_error_sms(mobile_number)
    	TwilioLib.send_text(mobile_number, "Unfortunately there was an error recognising your landline number. Please make sure it is correct and try again.")
    end

    def self.send_business_not_found_sms(mobile_number)
      TwilioLib.send_text(mobile_number, "Unfortunately this business does not participate in this program.")
    end

    def create_twilio_number
    	self.twilio_number = TwilioLib.create_phone_number(self.mobile_number,  {sms_url: "http://buynance-sms.herokuapp.com/businesses/#{self.id}/sms/recieve_sms"})
    end

    def find_customer_by_mobile_number(mobile_number)
      self.customers.find_by(mobile_number: GlobalPhone.parse(mobile_number).international_string)
    end

    def send_business_signup_acceptance
    	TwilioLib.send_text(self.mobile_number, "Congratulation you have been accepted to participate in this service. You new new number is #{self.twilio_number}.")
    end

    def has_customer(mobile_number)
      return self.customers.where(mobile_number: GlobalPhone.parse(mobile_number).international_string).size > 0
    end


    # Note: create an alternative if all opt in code are created.
    def create_opt_in_code
      opt_in_code = SecureRandom.random_number(9999999).to_s
      while Business.find_by(opt_in_code: opt_in_code)
      	opt_in_code = SecureRandom.random_number(9999999).to_s
      end
      self.opt_in_code = opt_in_code
    end

end