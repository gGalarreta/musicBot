class MessengerController < ApplicationController

  protect_from_forgery with: :null_session

  def index
    p params
    p params["hub.verify_token"]
    p params["hub.challenge"]
    if params["hub.verify_token"] == "Z4Q-L7t"
      render text: params["hub.challenge"]
    end
  end


end


