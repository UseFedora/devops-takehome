# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sinatra::Application do

  let(:app) { Sinatra::Application }

  it "works" do
    get "/"
    expect(last_response).to have_attributes(
      status: 200,
      body: "Hello World!",
    )
  end

end
