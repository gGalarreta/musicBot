class ChatService

  MENU_TEXT = "Cuentanos que deseas hacer"
  SEARCH_TITLE = "Buscar canciones"
  SEARCH_PAYLOAD = "buscar"
  QUESTION_MARKER = "cancion:"
  SEARCH_QUESTION = "Escribe la palabra 'cancion:' seguido del titulo de la cancion' "
  MUSIC_LIST_TITLE = "Ver favoritas"
  MUSIC_LIST_PAYLOAD = "listar"
  SEARCH_EMPTY_LIST = "No se encontro resultado"
  FAVORITE_EMPTY_LIST = "No tienes canciones favoritas"
  LIKE_MUSIC_TITLE = "Me gusta"
  DISLIKE_MUSIC_TITLE = "Remover"
  WELCOME_TEXT = "Bienvenido, deseas comenzar tu \n experiencia musical"
  WELCOME_OK = "bienvenido"
  WELCOME_NEGATE = "Tal ves despues"
  MENU_MARKER =" MENU"
  REPORT_TEXT = "Ver reportes"


  def initialize( user )
    @current_user = user
    @sender = user.fb_id
  end

  def send_search_question
    send_text_response(@sender, SEARCH_QUESTION)
  end

  def send_empty_list_message text
    send_text_response(@sender, text)
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
    matched_tracks = music_match_provider.search_track_by_name track.first(3)
    save_searched_tracks(matched_tracks)
    matched_tracks.empty? ? send_empty_list_message(SEARCH_EMPTY_LIST) : send_list(matched_tracks, LIKE_MUSIC_TITLE)
  end

  def send_favorite_tracks
    user = User.first
    favorite_tracks = user.favorite_tracks.first(3)
    favorite_tracks.empty? ? send_empty_list_message(FAVORITE_EMPTY_LIST) : send_list(favorite_tracks, DISLIKE_MUSIC_TITLE)
  end

  def send_list tracks_list, button_title
    #because we need a good view, we only show random 3 songs
    json_response = get_default_list
    tracks_list.each do |track|
      element = {
                "title": track.track_name,
                "subtitle": handle_track_data(track),
                "buttons":[
                  "title": "#{button_title}",
                  "type": "postback",
                  "payload": "#{track.to_hash.to_json}"
                  ]
                }
      json_response[:message][:attachment][:payload][:elements].push(element)
    end
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
                      },
                      {
                        "title": "#{REPORT_TEXT}",
                        "type": "web_url",
                        "url": ENV['SERVER_URL'] + "/reports",
                        "webview_height_ratio": "full"
                      }
                    ]  
                  }
                }
              }
            }
    HTTP.post(url, json: json_response)
  end

  def send_welcome
     json_response = {"recipient": {"id": "#{@sender}"},
            "message": {
                "attachment": {
                  "type": "template",
                  "payload": {
                    "template_type": "button",
                    "text": "#{WELCOME_TEXT}",
                    "buttons": [
                      {
                        "title": "#{WELCOME_OK}",
                        "type": "postback",
                        "payload": "#{WELCOME_OK}"
                      },
                      {
                        "title": "#{WELCOME_NEGATE}",
                        "type": "postback",
                        "payload": "#{WELCOME_NEGATE}"
                      }
                    ]  
                  }
                }
              }
            }
    HTTP.post(url, json: json_response)   
  end

  def get_default_list
     json_response = {"recipient": {"id": "#{@sender}"},
              "message": {
                "attachment": {
                  "type": "template",
                  "payload": {
                    "template_type": "list",
                    "top_element_style": "compact",
                    "elements": [],
                     "buttons": [
                      {
                        "title": "Volver al Menu",
                        "type": "postback",
                        "payload": "#{MENU_MARKER}"            
                      }
                    ]  
                  }
                }
              }
            }
      json_response 
  end


  def send_log_in
   json_response = {"recipient": {"id": "#{@sender}"},
          "message": {
              "attachment": {
                "type": "template",
                "payload": {
                  "template_type": "button",
                  "text": "Log In",
                  "buttons": [
                    {
                      "type": "account_link",
                      "url": ENV['SERVER_URL'] + "/session/new"
                    }                    
                  ]  
                }
              }
            }
          }
  HTTP.post(url, json: json_response)  
  end

  private

    def save_searched_tracks track_list
      @current_user.add_searched_tracks(track_list)
    end


end