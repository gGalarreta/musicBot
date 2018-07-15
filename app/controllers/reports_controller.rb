class ReportsController < ApplicationController

  before_action :set_report, only: [:index, :generate]

  def index
  end

  def generate
    @results = @report.generate(params)
  end


  private

    def set_report
      @report = Report.new()
    end

end
