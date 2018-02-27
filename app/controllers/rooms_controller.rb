class RoomsController < ApplicationController
  before_action :config_opentok,:except => [:index]
  def index
    @rooms = Room.where(:public => true).order("created_at DESC")
    @new_room = Room.new
  end

  def create
    session = @opentok.create_session
    params[:room][:sessionId] = session.session_id
    # byebug
    @new_room = Room.new(room_params)

    respond_to do |format|
      if @new_room.save
        format.html { redirect_to("/party/"+@new_room.id.to_s) }
      else
        format.html { render :controller => 'rooms',
          :action => "index" }
      end
    end
  end

  def party
    @room = Room.find(params[:id])
    time = Time.now.to_i + 3600
		@tok_token = @opentok.generate_token @room.sessionId, {
      :exipre_time => time,
      :data => {:name => ''}
    }
    # @tok_token = @opentok.create_session.generate_token

  end

  private
  def room_params
    params.require(:room).permit(:name, :sessionId, :public)
  end

  def config_opentok
    config = Rails.application.config_for(:webrtc)
    @api_key = Rails.application.config_for(:webrtc)["tokbox_api"]
    if @opentok.nil?
     # @opentok = OpenTok::OpenTokSDK.new 22329432, "f03a315fc996dff095d697eb7949cbec1474c6ba"
     @opentok = OpenTok::OpenTok.new config["tokbox_api"], config["tokbox_secret"]

    end
  end


  # def index
  #   config = Rails.application.config_for(:webrtc)
  #   @api_key = Rails.application.config_for(:webrtc)["tokbox_api"]
  #   opentok = OpenTok::OpenTok.new config["tokbox_api"], config["tokbox_secret"]
  #   # opentok = OpenTok::OpenTok.new OPENTOK_API_KEY, OPENTOK_SECRET_KEY
  #   @session = opentok.create_session
  #   @session_id = @session.session_id
  #   # generate opentok token
  #   @token = @session.generate_token
  # end
end
