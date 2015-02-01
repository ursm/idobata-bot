require 'json'
require 'net/http'
require 'open-uri'
require 'pp'
require 'pusher-client'
require 'mem'

module Idobata
	class Bot

		include Mem

		def run
			is_connected do 
				join_channel
				log_message
				listen
			end
			connect
		end

		def say(room_id, body)
			req = Net::HTTP::Post.new(idobata_messages_url.path, headers)
			req.form_data = { 'message[room_id]' => room_id, 'message[source]' => body }
			https = Net::HTTP.new(idobata_messages_url.host, idobata_messages_url.port)
			https.use_ssl = true
			https.start {|https| https.request(req)}
		end

		def to_say(room_id, name, body)
			say( room_id, "@#{name} #{body}" )
		end

		def is_connected(&block)
			socket.bind('pusher:connection_established', &block)
		end

		def name
		end

		def idobata_url
			URI.parse( ENV["IDOBATA_URL"] || "https://idobata.io/" )
		end

		def idobata_pusher_key
			ENV["IDOBATA_PUSHER_KEY"] || "44ffe67af1c7035be764"
		end

		def idobata_api_token
			ENV["IDOBATA_API_TOKEN"]
		end

		def idobata_seed_url
			URI.join(idobata_url, '/api/seed')
		end

		def idobata_pusher_auth_url
			URI.join(idobata_url, '/pusher/auth')
		end

		def idobata_messages_url
			URI.join(idobata_url, '/api/messages')
		end

		def headers
			{
			  'X-API-Token' => idobata_api_token,
			  'User-Agent'  => "idobata-bot / v#{Idobata::VERSION}"
			}
		end

		def seed_json
			idobata_seed_url.read(headers)
		end

		def seed
			JSON.parse(seed_json)
		end

		def records
			seed["records"]
		end

		def bot
			records["bot"]
		end

		def channel_name
			bot["channel_name"]
		end

		def auth_payload
			{
				socket_id: socket_id,
				channel_name: channel_name
			}
		end

		def authorize
			req = Net::HTTP::Post.new(idobata_pusher_auth_url.path, headers)
			req.form_data = auth_payload
			https = Net::HTTP.new(idobata_pusher_auth_url.host, idobata_pusher_auth_url.port)
			https.use_ssl = true
			https.start{ |https| https.request(req) }
		end

		def pusher_auth_json
			authorize.body
		end

		def pusher_auth
			JSON.parse pusher_auth_json
		end

		def socket
			PusherClient::Socket.new(idobata_pusher_key, encrypted: true)
		end

		def connect
			socket.connect
		end

		def connected?
			socket.connected
		end

		def socket_id
			socket.socket_id
		end

		def channel
			socket.channels.add(channel_name)
		end

		def join_channel
			socket.authorize_callback(channel, pusher_auth["auth"], pusher_auth["channel_data"])
		end

		def listen
			channel.bind('message:created') do |message_json|
				message = Message.new(JSON.parse(message_json)['message'])
				on_message(message)
				if is_myself_message(message)
					on_myself_message(message)
				end
			end
		end

		def log_message
			channel.bind('message:created') do |message_json|
				pp JSON.parse message_json
			end
		end

		def on_message(message)
			raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
		end

		def on_myself_message(message)
			raise NotImplementedError.new("You must implement #{self.class}##{__method__}")
		end

		def is_myself_message(message)
			message.to == name
		end

		memoize :name
		memoize :idobata_url
		memoize :idobata_pusher_key
		memoize :idobata_api_token
		memoize :idobata_seed_url
		memoize :idobata_pusher_auth_url
		memoize :idobata_messages_url
		memoize :headers
		memoize :seed_json
		memoize :seed
		memoize :records
		memoize :bot
		memoize :channel_name
		memoize :auth_payload
		memoize :authorize
		memoize :pusher_auth_json
		memoize :pusher_auth
		memoize :socket
		memoize :connect
		memoize :connected?
		memoize :socket_id
		memoize :channel
		memoize :join_channel
		memoize :listen
		memoize :log_message
		memoize :is_myself_message
	end
end


