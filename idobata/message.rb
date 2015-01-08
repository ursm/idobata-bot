
module Idobata
	class Message
	
		@message

		def initialize( message )
			@message = message
		end

		def to
			/@(.*)\s/ =~ body_plain
			$1
		end

		def to_body_plain
			/@.*\s(.*)/ =~ body_plain
			$1
		end

		def body_plain
			@message['body_plain']
		end

		def body
			@message['body']
		end

		def room_id
			@message['room_id']
		end

		def room_name
			@message['room_name']
		end

		def organization_slug
			@message['organization_slug']
		end

		def sender_id
			@message['sender_id']
		end

		def sender_name
			@message['sender_name']
		end
	end
end