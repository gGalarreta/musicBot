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
    auth = Auth.new(sender)
    current_user = auth.current_user()
    chat_service = ChatService.new(current_user)
    if payload
      postback = payload["payload"]
      if postback == ChatService::SEARCH_PAYLOAD
        chat_service.send_search_question()
      elsif postback == ChatService::MUSIC_LIST_PAYLOAD
        chat_service.send_favorite_tracks()
      elsif postback == ChatService::WELCOME_OK || postback == ChatService::MENU_MARKER
        chat_service.send_menu()
      else
        postback_title = payload["title"]
        if postback_title == ChatService::LIKE_MUSIC_TITLE
          current_user.add_favorite_track(postback)
        elsif postback_title == ChatService::DISLIKE_MUSIC_TITLE
          current_user.remove_favorite_track(postback)
        else
          ## default message
          chat_service.send_menu()
        end
      end
    else
      text = text["text"]
      if text.downcase.include? ChatService::QUESTION_MARKER
        chat_service.search_tracks(text)
      else
        ##init message
        chat_service.send_welcome()
        #chat_service.send_log_in()
      end
    end    
  end


end