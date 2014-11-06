class BusinessSmsController < ActionController

	def signup_business
		business_landline_number = params[:Body]
		business_mobile_number = params[:From]
		unless Business.find_by(business_phone_number)
			business = Business.create(landline_number: business_landline_number, mobile_number: business_mobile_number)
			if business
				business.create_twilio_number	
				business.passed_confirmation
			else
				Business.send_landline_parsing_error_sms(business_mobile_number)
			end
		else
			Business.send_business_found_sms(business_mobile_number)
		end
	end

	def recieve_sms
		incoming_mobile_number = params[:From]
		business = Business.find_by(id: params[:id])
		if business
			if business.mobile_number == incoming_mobile_number
				send_mass_sms
			else
				add_customer
			end
		else
			Business.send_business_not_found_sms(customer_mobile_number)
		end
	end

	private

		def add_customer
			customer_mobile_number = params[:From]
			business = Business.search_by_mobile_number(params[:To])

			unless business.nil?
				unless business.find_customer_by_mobile_number(customer_mobile_number)
					customer = Customer.create(mobile_number: customer_mobile_number)
					business.customers << customer
				else
					Business.send_customer_found_sms(customer_mobile_number)
				end
			else
				Business.send_business_not_found_sms(customer_mobile_number)
			end
		end

		def send_mass_sms
			business = Business.search_by_mobile_number(params[:To])

			unless business.nil?
				business.send_mass_sms_to_customers(params[:Body])
			else
				Business.send_business_not_found_sms(customer_mobile_number)
			end
		end

end