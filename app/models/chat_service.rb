class ChatService

  MENU_TEXT = "Cuentanos que deseas hacer"
  SEARCH_TITLE = "Buscar canciones"
  SEARCH_PAYLOAD = "buscar"
  QUESTION_MARKER = "cancion:"
  SEARCH_QUESTION = "Escribe la palabra 'cancion:' seguido del titulo de la cancion' "
  MUSIC_LIST_TITLE = "Ver favoritas"
  MUSIC_LIST_PAYLOAD = "listar"


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

  def send_search_question sender
    json_response = {"recipient": {"id": "#{sender}"},"message": {"text": "#{SEARCH_QUESTION}"}}
    HTTP.post(url, json: json_response)
  end

  def search_tracks sender, text
    track = text.downcase.gsub(QUESTION_MARKER, "").lstrip
    music_match_provider = MusicMatch.new()
    matched_tracks = music_match_provider.search_track_by_name track
    send_list(sender, matched_tracks)
  end

  def send_list sender, tracks_list
    #because we need a good view, we only show random 3 songs
    json_response = {"recipient": {"id": "#{sender}"},
              "message": {
                "attachment": {
                  "type": "template",
                  "payload": {
                    "template_type": "list",
                    "top_element_style": "compact",
                    "elements": [
                      {
                        "title": tracks_list.first.track_name,
                        "subtitle": tracks_list.first.artist_name
                      },
                      {
                        "title": tracks_list.second.track_name,
                        "subtitle": tracks_list.second.artist_name
                      },
                      {
                        "title": tracks_list.third.track_name,
                        "subtitle": tracks_list.third.artist_name   
                      }
                    ] 
                  }
                }
              }
            }
    HTTP.post(url, json: json_response)
  end


  def url
    "https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV['FB_CHAT_KEY']}"
  end

end