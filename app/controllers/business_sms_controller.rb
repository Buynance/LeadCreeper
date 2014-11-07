class BusinessSmsController < ApplicationController
	include Webhookable

	after_filter :set_header
  
  	skip_before_action :verify_authenticity_token

	def signup_business
		business_landline_number = params[:Body]
		business_mobile_number = params[:From]
		unless Business.find_by(mobile_number: business_mobile_number)
			business = Business.create(landline_number: business_landline_number, mobile_number: business_mobile_number)
			if business	
				business.passed_confirmation
			else
				Business.send_landline_parsing_error_sms(business_mobile_number)
			end
		else
			Business.send_business_found_sms(business_mobile_number)
		end

		response = Twilio::TwiML::Response.new do |r|
    	end

    	render_twiml response
	end

	def recieve_sms
		incoming_mobile_number = params[:From]
		business = Business.find_by(id: params[:id])
		if business
			if business.mobile_number == incoming_mobile_number
				recieve_business_sms
			else
				recieve_customer_sms
			end
		else
			Business.send_business_not_found_sms(customer_mobile_number)
		end

		response = Twilio::TwiML::Response.new do |r|
    	end

    	render_twiml response
	end

	private

		def recieve_customer_sms
			customer_mobile_number = params[:From]
			business = Business.search_by_mobile_number(params[:To])
			customer  = business.find_customer_by_mobile_number(customer_mobile_number)

			unless business.nil?
				unless customer
					new_customer = Customer.create(mobile_number: customer_mobile_number)
					business.customers << new_customer
					Customer.send_subscription_confirmation(new_customer.mobile_number, business.mobile_number)
				else
					subscription = BusinessesCustomer.where(business_id: business.id, customer_id: customer.id).last
					if subscription.subscribed?
						if params[:Body] == "remove"
							subscription.unsubscribe
							business.send_customer_unsubscribe_sms(customer_mobile_number)
						else
						  	business.send_customer_found_sms(customer_mobile_number)
						end
					elsif subscription.unsubscribed?
						if params[:Body] == "remove"
							business.send_customer_unsubscribe_sms(customer_mobile_number)
						else
							subscription.subscribe
						  	Customer.send_subscription_confirmation(customer_mobile_number, business.mobile_number)
						end
					end
				end
			else
				Business.send_business_not_found_sms(customer_mobile_number)
			end
		end

		def recieve_business_sms
			business = Business.search_by_mobile_number(params[:To])

			unless business.nil?
				business.send_mass_sms_to_customers(params[:Body])
			else
				Business.send_business_not_found_sms(customer_mobile_number)
			end
		end

end