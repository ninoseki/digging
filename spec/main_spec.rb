# frozen_string_literal: true

require 'rack/test'

describe "MainApp" do
  include Rack::Test::Methods

  def app
    MainApp
  end

  context "POST /" do
    it "should return JSON" do
      post "/", name: "google.com", type: "A"
      expect(last_response).to be_ok
      json = JSON.parse(last_response.body)
      expect(json).to be_a Hash
    end
  end
  context "POST / with JSON" do
    it "should return JSON" do
      post "/", { name: "google.com", type: "A" }.to_json, 'CONTENT_TYPE' => 'application/json'

      expect(last_response).to be_ok
      json = JSON.parse(last_response.body)
      expect(json).to be_a Hash
    end
  end
end
