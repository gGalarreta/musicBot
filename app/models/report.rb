class Report

  attr_accessor :type

  MONTHS = ["january","february","march","april","may","june","july","august","september","october","november","december"]
  USER_OPTION = "usuarios"
  CHAT_OPTION = "chats"
  SONG_OPTION = "canciones populares por favoritos"
  SEARCH_OPTION = "canciones populares por busquedas"
  WRITTEN_WORDS_OPTION = "que se escribio"

  def initialize()
    @type = ""
  end


  def options
    [USER_OPTION, CHAT_OPTION, SONG_OPTION, SEARCH_OPTION, WRITTEN_WORDS_OPTION]
  end

  def frequencies
    MONTHS
  end

  def generate(args = {} )
    @results = []
    report_type = args[:report_type]
    start_report_frequency = args[:start_report_frequency]
    finalt_report_frequency = args[:final_report_frequency]
    @type = report_type
    if valid_params?(report_type, start_report_frequency)
      case report_type
      when USER_OPTION
        @results = generate_report_struct(User.all, start_report_frequency, finalt_report_frequency)
      when CHAT_OPTION
        @results = generate_report_struct(Conversation.all, start_report_frequency, finalt_report_frequency)
      when SONG_OPTION
        @results = generate_generic_struct(FavoriteTrack.all, "track_name")
      when WRITTEN_WORDS_OPTION
        @results = get_words_in_database(Conversation.all, :text)
      else
        @results = generate_generic_struct(SearchedTrack.all, "track_name")
      end
    end
  end

  def is_for_songs
    @type == SEARCH_OPTION || @type == WRITTEN_WORDS_OPTION
  end

  private 

    def valid_params?(type, frequency)
      type && frequency
    end

    def generate_report_struct data, report_frequency_start, report_frequency_end
      values = []
      current_year =  Time.new.year
      for index in MONTHS.index(report_frequency_start)...(MONTHS.index(report_frequency_end)+1)
        current_month = Time.new(current_year, index+1, 1)
        elements = data.where("created_at > ? AND created_at < ?", current_month.beginning_of_month, current_month.end_of_month)
        current_value = [MONTHS[index], elements.size]
        values.push(current_value)
      end
      values
    end

    def generate_generic_struct data, label
      values = []
      data.group(label).count.each do |k, v|
        current_value = [k, v]
        values.push(current_value)
      end
      values
    end

    def get_words_in_database data, label
      text = data.map(&label).map { |k| "#{k}" }.join(" ")
      tokens = Phrase.new(text)
      tokens.word_count.sort {|a1,a2| a2[1]<=>a1[1]}
    end


end