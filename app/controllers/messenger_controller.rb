class MessengerController < ApplicationController

  def index
    if params["hub.verify_token"] == ENV['WEBHOOK_TOKEN']
      render :json => params["hub.challenge"]
    end
  end


  def recieved_data
    chat_request = request.body.read
    data = JSON.parse(chat_request)
    parse_data(data)
  end

 def parse_data(data)
    enteries = data["entry"]
    enteries.each do |entry|
      entry["messaging"].each do |messaging|
        sender = messaging["sender"]["id"]
        text = messaging["message"]["text"]
        payload = messaging["payload"]
        analysis(sender, text, payload)
      end
    end
  end

  def analysis sender, text, payload
    chat_service = ChatService.new()
    if payload
      chat_service.send_search if payload == "buscar"
      chat_service.send_list if payload == "listar"
    else
      chat_service.send_menu(sender)
    end    
  end

end