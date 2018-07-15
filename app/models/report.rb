class Report

  MONTHS = ["january","february","march","april","may","june","july","august","september","october","november","december"]
  USER_OPTION = "usuarios"
  CHAT_OPTION = "chats"
  SONG_OPTION = "canciones"
  SEARCH_OPTION = "busquedas"

  def initialize()
  end


  def options
    [USER_OPTION, CHAT_OPTION, SONG_OPTION, SEARCH_OPTION]
  end

  def frequencies
    MONTHS
  end

  def generate(args = {} )
    @results = []
    report_type = args[:report_type]
    start_report_frequency = args[:start_report_frequency]
    finalt_report_frequency = args[:final_report_frequency]
    if valid_params?(report_type, start_report_frequency)
      case report_type
      when USER_OPTION
        generate_report_struct(User.all, start_report_frequency, finalt_report_frequency)
      when CHAT_OPTION
        generate_report_struct(User.all, start_report_frequency, finalt_report_frequency)
      when SONG_OPTION
        generate_report_struct(User.all, start_report_frequency, finalt_report_frequency)
      else
        generate_report_struct(User.all, start_report_frequency, finalt_report_frequency)
      end
    end
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



end