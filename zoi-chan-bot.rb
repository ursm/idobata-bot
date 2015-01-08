require 'json'

module Idobata
	class ZoiChanBot < Bot

		def name
			"zoi-chan"
		end
		
		def on_message(message)
		end

		def on_myself_message(message)
			to_body_plain = message.to_body_plain()
			if /今日も一日/ =~ to_body_plain
				to_say( message.room_id, message.sender_name, "がんばるぞい!" )
			end
			if /おはよう$/ =~ to_body_plain || /おはー$/ =~ to_body_plain || /おは$/ =~ to_body_plain
				to_say( message.room_id, message.sender_name, "おはようございます！ 今日も一日がんばるぞい！");
			end
			if /こんにちは$/ =~ to_body_plain || /こにちはー$/ =~ to_body_plain || /こん$/ =~ to_body_plain
				to_say( message.room_id, message.sender_name, "こんにちは！ 午後もがんばってください！")
			end
			if /こんばんは$/ =~ to_body_plain || /ばんー$/ =~ to_body_plain || /ばん$/ =~ to_body_plain
				to_say( message.room_id, message.sender_name, "こんばんは！ 無理をしすぎないようにしてください！")
			end
			if /(.*)？/ =~ to_body_plain || /(.*)\?/ =~ to_body_plain
				question = $1
				if /(.*)って何$/ =~ question || /(.*)って$/ =~ question
					question = $1
				end
				if /(.*)みせてー$/ =~ question || /(.*)みせて$/ =~ question || /(.*)見せて$/ =~ question || /(.*)見せてー$/ =~ question
					question = $1
				end
				if /(.*)について/ =~ question
					question = $1
				end
				url = get_image_url(question)
				if !url.nil?
					to_say( message.room_id, message.sender_name, question + " はこちらでしょうか! " + url)
				else
					to_say( message.room_id, "ごめんなさい. わからないです・・。")
				end
			end
		end

		def get_image_url(search)
			params = URI.encode("q=#{search}&lr=lang_ja&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:ja:official&client=firefox-a&v=1.0&rsz=large&start=#{rand(10)}");
			response = Net::HTTP.get(
				'ajax.googleapis.com',
				'/ajax/services/search/images?'+params
			)
			responseJson = JSON.parse(response)
			responseResults = responseJson['responseData']['results']
			responseResults.at( rand(8) )['url']
		end

	end
end