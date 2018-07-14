class ChatService

  MENU_TEXT = "Cuentanos que deseas hacer"
  SEARCH_TITLE = "Buscar canciones"
  SEARCH_PAYLOAD = "buscar"
  QUESTION_MARKER = "cancion:"
  SEARCH_QUESTION = "Escribe la palabra 'cancion:' seguido del titulo de la cancion' "
  MUSIC_LIST_TITLE = "Ver favoritas"
  MUSIC_LIST_PAYLOAD = "listar"
  EMPTY_LIST = "No se encontro resultado"
  FAVORITE_MUSIC_TITLE = "Me gusta"
  NO_FAVORITE_MUSIC_TITLE = "Ya no me gusta"


  def initialize( sender )
    @sender = sender
  end

  def send_search_question
    send_text_response(@sender, SEARCH_QUESTION)
  end

  def send_empty_list_message
    send_text_response(@sender, EMPTY_LIST)
  end

  def url
    "https://graph.facebook.com/v2.6/me/messages?access_token=#{ENV['FB_CHAT_KEY']}"
  end

  def handle_track_data track
    "artista: #{track.artist_name}\n
     album: #{track.album_name}\n"
  end

  def send_text_response sender, text
    json_response = {"recipient": {"id": "#{sender}"},"message": {"text": "#{text}"}}
    HTTP.post(url, json: json_response)
  end

  def search_tracks text
    track = text.downcase.gsub(QUESTION_MARKER, "").lstrip
    music_match_provider = MusicMatch.new()
    matched_tracks = music_match_provider.search_track_by_name track
    matched_tracks.empty? ? send_empty_list_message() : send_list(matched_tracks, FAVORITE_MUSIC_TITLE)
  end

  def send_list tracks_list, button_title
    #because we need a good view, we only show random 3 songs
    json_response = {"recipient": {"id": "#{@sender}"},
              "message": {
                "attachment": {
                  "type": "template",
                  "payload": {
                    "template_type": "list",
                    "top_element_style": "compact",
                    "elements": [
                      {
                        "title": tracks_list.first.track_name,
                        "subtitle": handle_track_data(tracks_list.first),
                        "buttons":[
                          "title": "#{button_title}",
                          "type": "postback",
                          "payload": "#{tracks_list.first.track_name}"
                        ]
                      },
                      {
                        "title": tracks_list.second.track_name,
                        "subtitle": handle_track_data(tracks_list.second),
                        "buttons":[
                          "title": "#{button_title}",
                          "type": "postback",
                          "payload": "#{tracks_list.second.track_name}"
                        ]
                      },
                      {
                        "title": tracks_list.third.track_name,
                        "subtitle": handle_track_data(tracks_list.third),
                        "buttons":[
                          "title": "#{button_title}",
                          "type": "postback",
                          "payload": "#{tracks_list.third.track_name}"
                        ]
                      }
                    ] 
                  }
                }
              }
            }
    HTTP.post(url, json: json_response)
  end

  def send_menu 
    json_response = {"recipient": {"id": "#{@sender}"},
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

end