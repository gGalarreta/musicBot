class MessengerController < ApplicationController

  def index
    if params["hub.verify_token"] == ENV['WEBHOOK_TOKEN']
      render :json => params["hub.challenge"]
    end
  end


  def recieved_data
    chat_request = request.body.read
    p "---------------------------"
    p chat_request
    p "---------------------------"
    data = JSON.parse(chat_request)
    parse_data(data)
  end

 def parse_data(data)
    chat_service = ChatService.new()
    enteries = data["entry"]
    enteries.each do |entry|
      entry["messaging"].each do |messaging|
        sender = messaging["sender"]["id"]
        #text = messaging["message"]["text"]
        chat_service.send_menu(sender)
      end
    end
  end

end