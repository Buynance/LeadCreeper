class TwilioLib
	twilio_sid = "AC06cc45d9a750321891277d6274021f8a"
    twilio_token = "337632369154ce324e619aa7c92af540"
    @twilio_phone_number = "+17162093070"

    @twilio_client = Twilio::REST::Client.new twilio_sid, twilio_token


	def self.create_phone_number(local_number,  options={})
		options[:sms_url] ||= ""
		options[:voice_url] ||= ""

		area_code = local_number[2, 3]

		numbers = @twilio_client.account.available_phone_numbers.get('US').local.list(:area_code => area_code)

		unless numbers.size > 0
			numbers = @twilio_client.account.available_phone_numbers.get('US').local.list(:in_region => "NY")
			unless numbers.size > 0
				numbers = @twilio_client.account.available_phone_numbers.local.list()
			end
		end

		@twilio_client.account.incoming_phone_numbers.create(
			:voice_url => options[:voice_url],
			:sms_url => options[:sms_url],
			:phone_number => numbers[0].phone_number
			)

  		return numbers[0].phone_number
	end

	def self.generate_voice_xml(phone_number, options={})
		options[:record] ||= true
		options[:transcribe] ||= false

		response = '<?xml version="1.0" encoding="UTF-8"?><Response><Dial timeout="20" record="true">#{phone_number}</Dial></Response>'
		response.text
	end

	def self.send_text(phone_number, message, twilio_number = @twilio_phone_number)
		return_val = @twilio_client.account.messages.create(:body => message,
    		:to => phone_number,
    		:from => twilio_number)
	end
end