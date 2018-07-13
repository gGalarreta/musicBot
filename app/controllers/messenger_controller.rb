class MessengerController < ApplicationController

  protect_from_forgery with: :null_session

  def index

    if params["hub.verify_token"] == "Z4Q-L7t"
      p "------------->"
      respond_to do |format|
        format.html { render text: params["hub.challenge"]}
        #format.html { render text: "here"}
      end
    end

  end


end


