# frozen_string_literal: true

require "json"
require "sinatra"

class MainApp < Sinatra::Application
  get "/" do
    send_file File.join(settings.public_folder, "index.html")
  end

  post "/" do
    begin
      json = JSON.parse(request.body.read)
    rescue JSON::ParserError => _e
      json = {}
    end

    name = params["name"] || json["name"]
    type = params["type"] || json["type"]
    server = params["server"] || json["server"]

    hashes = []

    begin
      digger = Digger.new(name, type, server)

      resources = digger.resources
      hashes = resources.map do |resource|
        Converter.to_hash(resource)
      end
    rescue Digger::InvalidTypeError => _e
      content_type :json
      status 400

      return { error: "#{type} is an invalid type. Acceptable types: A, AAAA, CNAME, NX, NS, SOA, TXT." }.to_json
    rescue Converter::InvalidResourceError => _e
      content_type :json
      status 400

      return { error: "Invalid resource error" }.to_json
    rescue Resolv::ResolvError => e
      content_type :json
      status 400

      return { error: e.to_s }.to_json
    end

    content_type :json

    hashes.to_json
  end
end
