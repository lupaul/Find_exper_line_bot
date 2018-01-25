module Ai::Conversation
  require 'net/http'

  def self.get_response(message,session_id)
    _get_response(message,session_id)
  end

  private

  def self._get_response(message,session_id)
    token = Rails.application.config_for(:api_key)["api_ai"]["token"]
    api_url = Rails.application.config_for(:api_key)["api_ai"]["api_url"]
    uri = URI(api_url)
    res = JSON.parse(Net::HTTP.post_form(uri,token: token, query: message, session_id: session_id).body)["answer"]
    return res

  end

end
