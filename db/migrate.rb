# frozen_string_literal: true

require "sequel"

DB = Sequel.connect(ENV.fetch("DATABASE_URL"))

DB.create_table(:widgets) do
  primary_key :id
  String :name
end
