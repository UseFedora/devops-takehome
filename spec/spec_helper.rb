# frozen_string_literal: true

require "rack/test"

ENV["DATABASE_URL"] ||= "postgres://localhost:5432/devops_test"

require_relative "../app"

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.disable_monkey_patching!
end
