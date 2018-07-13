class MessengerController < ApplicationController

  def index
    if params["hub.verify_token"] == "Z4Q-L7t"
      render :json => {:value => params["hub.challenge"]}.to_json
    end
  end

end


