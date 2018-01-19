module NaverLine::LineBotService

  def self.push(line_user_id, message_content)
    _push(line_user_id, message_content)
  end

  private

  def self._push(line_user_id, message_content)
    client = Line::Bot::Client.new do |config|
      config.channel_secret = Rails.application.config_for(:api_key)["line"]["channel_secret"]
      config.channel_token = Rails.application.config_for(:api_key)["line"]["channel_access_token"]
    end
    message = {
      type: 'text',
      text: message_content
    }
    response = client.push_message(line_user_id, message)
    Rails.logger.info "result: #{response.inspect}"
    result = {
      result: true,
      response: {
        code: response.code,
        body: response.body
      }
    }
    # render :json => {
    #   result: true,
    #   :response => {
    #     code: response.code,
    #     body: response.body
    #   }}
  end

end
