class Api::V1::ChatsController < Api::V1::ApplicationController

  def chat

    message = params[:data]
    type = params[:type]
    session_id = params[:id]
    config = Rails.application.config_for(:webrtc)
    res = RestClient.post "https://api.opentok.com/v2/project/#{config["tokbox_api"]}/session/#{session_id}/signal", {type:type,data:message}.to_json, {"Content-Type" => "application/json","X-TB-PARTNER-AUTH" => "#{config["tokbox_api"]}:#{config["tokbox_secret"]}" }
    render json: {
      value: 1
    }

  end
end
