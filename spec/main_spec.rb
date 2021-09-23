# frozen_string_literal: true

require "rack/test"

describe "MainApp" do
  include Rack::Test::Methods

  def app
    MainApp
  end

  describe "POST /" do
    context "with form-data params" do
      it "should return JSON" do
        post "/", name: "google.com", type: "A"
        expect(last_response).to be_ok
        json = JSON.parse(last_response.body)
        expect(json).to be_a Hash
      end
    end

    context "with JSON params" do
      it "should return JSON" do
        post "/", { name: "google.com", type: "A" }.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response).to be_ok
        json = JSON.parse(last_response.body)
        expect(json).to be_a Hash
      end
    end
  end
end
