class ArchivesController < ApplicationController
  def index
    @months = Email
      .where(in_reply_to: nil)
      .group("date_trunc('month', date)")
      .order(1)
      .pluck(Arel.sql("date_trunc('month', date), count(*)"))
  end

  def show
    @month = params[:month].to_datetime
    @threads = Email
      .where(in_reply_to: nil)
      .where(Arel.sql("date_trunc('month', date) = ?", @month))
      .order(:date)
  end
end
