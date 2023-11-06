require "sinatra"
require "active_record"

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  host: "localhost",
  port: 5432,
  database: "govuk_chat_dashboard_development",
)

class Answer < ActiveRecord::Base
end

get "/" do
  charts = []
  labels = Answer.all.where.not(header: "any_other_comments").map(&:header).uniq
  labels.each do |label|
    data = Answer.all.where.not(value: nil).where(header: label).group(:value).count
    charts << { label: label, data: data }
  end
  @charts = charts.to_json

  erb :index
end
