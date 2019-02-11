# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sinatra::Application do

  let(:app) { Sinatra::Application }

  it "shows index page with widgets" do
    name = SecureRandom.uuid
    DB[:widgets].insert(name: name)
    get "/"
    expect(last_response.status).to eq 200
    expect(last_response.body).to include name
  end

  it "creates a new widget" do
    name = SecureRandom.uuid
    expect {
      post "/widgets", name: name
    }.to change {
      DB[:widgets].count
    }.by 1
    expect(last_response.status).to eq 302
    expect(last_response.location).to eq "http://example.org/"
  end

end
