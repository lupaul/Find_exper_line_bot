module Tokbox::Chat
  require 'net/http'

  def self.all_clients_to_session(session_id,message)
    self._all_clients_to_session(session_id, message)
  end

  private

  def _all_clients_to_session(session_id, message)
    SESSION_ID = session_id
    API_KEY=123456
    JWT=jwt_token # replace with a JSON web token (see "Authentication")
    DATA='{"type":"foo","data":"bar"}'
    curl -v \
    -H "Content-Type: application/json" \
    -X POST \
    -H "X-OPENTOK-AUTH:${JWT}" \
    -d "${DATA}" \
    https://api.opentok.com/v2/project/${API_KEY}/session/${SESSION_ID}/signal


    

  end
end

config = Rails.application.config_for(:webrtc)
#   @api_key = Rails.application.config_for(:webrtc)["tokbox_api"]
#   opentok = OpenTok::OpenTok.new config["tokbox_api"], config["tokbox_secret"]
#   # opentok = OpenTok::OpenTok.new OPENTOK_API_KEY, OPENTOK_SECRET_KEY
#   @session = opentok.create_session
#   @session_id = @session.session_id
#   # generate opentok token
#   @token = @session.generate_token
