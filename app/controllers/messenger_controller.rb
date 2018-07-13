class MessengerController < ApplicationController

  def index
    if params["hub.verify_token"] == "Z4Q-L7t"
      render :json => params["hub.challenge"]
    end
  end

  def search
    p "ESTOY EN EL SEARCH"
    send_message2("1860488127349564", "ESTAS BUSCANDO")
    render :json => "hola"
=begin
    therequest = request.body.read
    p therequest
    data = JSON.parse(therequest)
    message = "BUSCANDO"
    parse_data2(data, message)
=end
  end

  def favorites
    p "ESTOY EN FAVORITOS"
    therequest = request.body.read
    p therequest
    data = JSON.parse(therequest)
    message = "LISTANDO"
    parse_data2(data)
  end

  def recieved_data
    therequest = request.body.read
    p therequest
    data = JSON.parse(therequest)
    parse_data(data)
  end

 def parse_data(data)
    enteries = data["entry"]
    enteries.each do |entry|
      entry["messaging"].each do |messaging|
        sender = messaging["sender"]["id"]
        text = messaging["message"]["text"]
        analysis(sender, text.downcase)
      end
    end
  end

  def analysis(sender, text)
    #message = Message.where(:recieved => text).first
    message = "Hola"
    #if message
    #  reply = message.reply
    #else
    #  reply = "Sorry not found"
    #end
    send_message(sender, message)
  end

 def parse_data2(data, message)
    enteries = data["entry"]
    enteries.each do |entry|
      entry["messaging"].each do |messaging|
        sender = messaging["sender"]["id"]
        text = messaging["message"]["text"]
        analysis(sender, message)
      end
    end
  end

  def analysis2(sender, text)
    #message = Message.where(:recieved => text).first
    message = text
    #if message
    #  reply = message.reply
    #else
    #  reply = "Sorry not found"
    #end
    send_message2(sender, message)
  end

  def send_message2(sender, text)
    myjson = {"recipient": {"id": "#{sender}"},"message": {"text": "#{text}"}}
    puts HTTP.post(url, json: myjson)
  end

  def send_message(sender, text)
    myjson = {"recipient": {"id": "#{sender}"},
                "message": {
                    "attachment": {
                      "type": "template",
                      "payload": {
                        "template_type": "button",
                        "text":"What do you want to do next?",
                        "buttons": [
                          {
                            "title": "buscar",
                            "type": "web_url",
                            "url": "https://intense-lake-18448.herokuapp.com/messenger/search"
                          },
                          {
                            "title": "listar",
                            "type": "web_url",
                            "url": "https://intense-lake-18448.herokuapp.com"
                          }
                        ]  
                      }
                    }
                  }
                }
    puts HTTP.post(url, json: myjson)
  end

  def url
    "https://graph.facebook.com/v2.6/me/messages?access_token=EAAGh4t6DADsBAHt7Qd4U1A6fIwGP3whOOqk2d7IvkPaEFFmjoNZAZAJbjFQYzfvZBwZBMtxifNSm0r8hz5C8iAjMZCVXGocVzwz6fJ3iHjqBojqP01VTDy6cnTD5YcLqmgCk3GBu4ktBS4M8kzQ1pwQCkWMcPtL1pGuis1IC5dwZDZD"
  end

end


