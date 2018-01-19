class NaverLines::ApplicationController < ApplicationController
  skip_before_action :verify_authenticity_token

	def webhooks
		params["events"].each do |event|
			message = parse_line_message_event(event)
			Rails.logger.info "parsed_line_message: #{message}"
			if message[:result] != true
				Rails.logger.info "line_webhook parse fail: #{message}"
				return render :json => {}
			end
			case message[:type]
			when "follow"
				line_user_id = message[:source][:user_id]
				line_user = NaverLine::Account.find_or_initialize_by(:line_user_id => line_user_id)

				line_user.line_time_at = Time.at(message[:line_time_at].to_i/1000)
				line_user.save

			when "message"
				content = message[:message][:text]
				Rails.logger.info "get_line_message: #{content}"
				client = Line::Bot::Client.new do |config|
				  config.channel_secret = Rails.application.config_for(:api_key)["line"]["channel_secret"]
				  config.channel_token = Rails.application.config_for(:api_key)["line"]["channel_access_token"]
				end

				case content.try(:downcase)
				when "?"
					response = client.reply_message(message[:reply_token], {
						type: "text",
						text: "您好\n查詢你的物件請填寫 a \n查詢你的數據請填寫 b"
						})
					Rails.logger.info "got_question_mark"
					return render :json => {result: true, :response => response}
				when "a"
					content = user_eye_objets(message[:source][:user_id])
					line_user = NaverLine::Account.find_by(:line_user_id => line_user_id)
					member = line_user.try(:member)
					if member
						eye_collections = EyeCollection.includes(:eye_object).where(:id => member.eye_collections.map(&:id))
						content = eye_collections.map{|ec| "#{ec.eye_object.name} #{ec.live_url}"}.join("\n")
					else
						content = "沒有物件"
					end
					client.reply_message(message[:reply_token], {
						type: "text",
						text: content})
					return render :json => {result: true}
				when "c"
					client.reply_message(message[:reply_token], {
					  type: "template",
					  altText: "this is a carousel template",
					  template: {
				      type: "carousel",
				      columns: [
			          {
			            thumbnailImageUrl: "https://www.eyehouse.co/images/logo/logo_fb_pic.jpg",
			            title: "this is menu",
			            text: "description",
			            actions: [
		                {
		                    type: "postback",
		                    label: "Buy",
		                    data: "action=buy&itemid=111"
		                },
		                {
		                    type: "postback",
		                    label: "Add to cart",
		                    data: "action=add&itemid=111"
		                },
		                {
		                    type: "uri",
		                    label: "View detail",
		                    uri: "http://example.com/page/111"
		                }
			            ]
			          },
			          {
			            thumbnailImageUrl: "https://www.eyehouse.co/images/logo/logo_fb_pic.jpg",
			            title: "this is menu",
			            text: "description",
			            actions: [
		                {
		                    type: "postback",
		                    label: "Buy",
		                    data: "action=buy&itemid=222"
		                },
		                {
		                    type: "postback",
		                    label: "Add to cart",
		                    data: "action=add&itemid=222"
		                },
		                {
		                    type: "uri",
		                    label: "View detail",
		                    uri: "http://example.com/page/222"
		                }
			            ]
			          }
				      ]
					  }
					})
				else
					return render :json => {result: true}
				end
			else

			end
		end
		render :json => {}
	end

	private

	def parse_line_message_event(line_event)
		message = {
			:type => line_event["type"],
			:reply_token => line_event["replyToken"],
			:line_time_at => line_event["timestamp"],
		}
		begin
			case line_event["type"]
			when "follow"
				message[:result] = true
				message[:source] = {
					type: line_event["source"]["type"],
					user_id: line_event["source"]["userId"]
				}
			when "unfollow"
				message[:result] = false
				message[:message] = "not handle yet, type: #{line_event["type"]}"

			when "message"
				message[:result] = true
				message[:source] = {
					type: line_event["source"]["type"],
					user_id: line_event["source"]["userId"]
				}
				if line_event["message"]["type"] == "text"
					message[:message] = {
						id: line_event["message"]["id"],
						type: line_event["message"]["type"],
						text: line_event["message"]["text"]
					}
				else
					message[:message] = {
						id: line_event["message"]["id"],
						type: line_event["message"]["type"]
					}
				end

			when "leave"
				message[:result] = false
				message[:message] = "not handle yet, type: #{line_event["type"]}"

			when "postback"
				message[:result] = false
				message[:message] = "not handle yet, type: #{line_event["type"]}"

			else
				message[:result] = false
				message[:message] = "unknown type: #{line_event["type"]}"

			end

		rescue Exception => e
			Rails.logger.error "parse_line_message_event_fail: #{e}"
			message[:result] = false
			message[:message] = e
		end
		message
	end

	def user_eye_objets(line_user_id)
		line_user = NaverLine::Account.find_by(:line_user_id => line_user_id)
		member = line_user.try(:member)
		if member
			eye_collections = EyeCollection.includes(:eye_object).where(:id => member.eye_collections.map(&:id))

			content = eye_collections.map{|ec| "#{ec.eye_object.name} #{ec.live_url}"}.join("\n")
		else
			content = "沒有物件"
		end
		content
	end

	#message example
	# render :json => {
	#   "events": [
	#       {
	#         "replyToken": Rails.application.config_for(:api_key)['line'],
	#         "type": "message",
	#         "timestamp": Time.now.to_i,
	#         "source": {
	#              "type": "user",
	#              "userId": "crsgypin"
	#          },
	#          "message": {
	#              "id": "325708",
	#              "type": "text",
	#              "text": "Hello, world"
	#           }
	#       }
	#   ]
	# }

end
