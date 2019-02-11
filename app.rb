# frozen_string_literal: true

require "sequel"
require "sinatra"
require "slim"

DB = Sequel.connect(ENV.fetch("DATABASE_URL"))

configure do
  enable :raise_errors
  disable :show_exceptions
end

get "/" do
  @widgets = DB[:widgets].all
  slim :index
end

post "/widgets" do
  DB[:widgets].insert(name: params[:name])
  redirect "/"
end
