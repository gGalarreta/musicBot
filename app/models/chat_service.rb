class ChatService

  MENU_TEXT = "Cuentanos que deseas hacer"
  SEARCH_TITLE = "Deseas buscar canciones?"
  SEARCH_PAYLOAD = "BUSCAR"
  MUSIC_LIST_TITLE = "Deseas listar tus canciones favoritas?"
  MUSIC_LIST_PAYLOAD = "LISTAR"


  def initialize()
  end

  def send_menu sender 
    json_response = {"recipient": {"id": "#{sender}"},
            "message": {
                "attachment": {
                  "type": "template",
                  "payload": {
                    "template_type": "button",
                    "text": "#{MENU_TEXT}",
                    "buttons": [
                      {
                        "title": "#{SEARCH_TITLE}",
                        "type": "postback",
                        "payload": "#{SEARCH_PAYLOAD}"
                      },
                      {
                        "title": "#{MUSIC_LIST_TITLE}",
                        "type": "postback",
                        "payload": "#{MUSIC_LIST_PAYLOAD}"
                      }
                    ]  
                  }
                }
              }
            }
    HTTP.post(url, json: json_response)
  end

  def url
    "https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV.fetch(FB_CHAT_KEY)}"
  end

end