module Ai::Conversation
  require 'net/http'
  require 'digest'

  def self.get_response(message,session_id)
    _get_response(message,session_id)
  end

  private

  def self._get_response(message,session_id)
    timestamp = (Time.now.to_i).to_s + "000"
    api_url = Rails.application.config_for(:api_key)["api_ai"]["api_url"]
    key = Rails.application.config_for(:api_key)["api_ai"]["key"]
    secret = Rails.application.config_for(:api_key)["api_ai"]["secret"]
    sign_key = Digest::MD5.hexdigest "#{secret}api=nliappkey=#{key}timestamp=#{timestamp}#{secret}"
    uri = URI(api_url)
    response = Net::HTTP.post_form(uri,,appkey: key,
              api: "nli",
              timestamp: timestamp,
              sign: sign_key,
              rq: "{'data':{'input_type':1,'text': #{message}},'data_type':'stt'}",
              cusid: session_id)
    res = JSON.parse(response.body)["data"]["nli"][0]["desc_obj"]["result"]
    return res

  end

  # def self._get_response(message,session_id)
  #   token = Rails.application.config_for(:api_key)["api_ai"]["token"]
  #   api_url = Rails.application.config_for(:api_key)["api_ai"]["api_url"]
  #   uri = URI(api_url)
  #   res = JSON.parse(Net::HTTP.post_form(uri,token: token, query: message, session_id: session_id).body)["answer"]
  #   return res
  #
  # end

end
