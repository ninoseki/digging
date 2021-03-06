# frozen_string_literal: true

require "json"
require "sinatra"

class MainApp < Sinatra::Application
  get '/' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  post "/" do
    begin
      json = JSON.parse(request.body.read)
    rescue JSON::ParserError => _
      json = {}
    end
    name = params["name"] || json["name"]
    type = params["type"] || json["type"]
    server = params["server"] || json["server"]

    begin
      digger = Digger.new(name, type, server)
      resource = digger.get_resource
      hash = Converter.to_hash(resource)

      content_type :json
      hash.to_json
    rescue Digger::InvalidTypeError => _
      status 400
      "#{type} is an invalid type. Acceptable types: A, AAAA, CNAME, NX, NS, SOA, TXT."
    rescue Converter::InvalidResourceError => _
      status 400
      "Invalid resource error"
    rescue Resolv::ResolvError => e
      status 400
      e.to_s
    end
  end
end
