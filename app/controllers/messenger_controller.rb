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
        text = messaging["message"]
        payload = messaging["postback"]
        analysis(sender, text, payload)
      end
    end
  end

  def analysis sender, text, payload
    chat_service = ChatService.new(sender)

    if payload
      postback = payload["payload"]
      if postback == ChatService::SEARCH_PAYLOAD
        chat_service.send_search_question()
      elsif postback == ChatService::MUSIC_LIST_PAYLOAD
        chat_service.send_favorite_tracks()
      else
        postback_title = payload["title"]
        if postback_title == ChatService::FAVORITE_MUSIC_TITLE
          # falta manejar el user
          User.first.add_favorite_track(payload)
        else
          chat_service.send_menu()
        end
      end
    else
      text = text["text"]
      if text.downcase.include? ChatService::QUESTION_MARKER
        chat_service.search_tracks(text)
      else
        chat_service.send_menu()
      end
    end    
  end

end