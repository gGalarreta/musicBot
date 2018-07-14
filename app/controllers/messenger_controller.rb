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
        payload = messaging["postback"]["payload"]
        analysis(sender, text, payload)
      end
    end
  end

  def analysis sender, text, payload
    chat_service = ChatService.new()
    if payload
      chat_service.send_search_question(sender) if payload == ChatService::SEARCH_PAYLOAD
      chat_service.send_list if payload == ChatService::MUSIC_LIST_PAYLOAD
    else
      if text.downcase.include? ChatService::QUESTION_MARKER
        chat_service.search_tracks(sender, text)
      else
        chat_service.send_menu(sender)
      end
    end    
  end

end