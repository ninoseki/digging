require "resolv"
require "ipaddr"

class Digger
  attr_reader :name, :type, :server

  class InvalidTypeError < StandardError; end

  TYPE_CLASSES = {
    A:      Resolv::DNS::Resource::IN::A,
    AAAA:   Resolv::DNS::Resource::IN::AAAA,
    CNAME:  Resolv::DNS::Resource::IN::CNAME,
    MX:     Resolv::DNS::Resource::IN::MX,
    NS:     Resolv::DNS::Resource::IN::NS,
    SOA:    Resolv::DNS::Resource::IN::SOA,
    TXT:    Resolv::DNS::Resource::IN::TXT,
  }.freeze

  def initialize(name, type, server)
    raise InvalidTypeError unless valid_type?(type)

    @name = name
    @type = TYPE_CLASSES[type.upcase.to_sym]
    server = "8.8.8.8" if server.nil?
    @server = Resolv::DNS.new(nameserver: [server])
  end

  def get_resource
    server.getresource(name, type)
  end

  def valid_type?(type)
    TYPE_CLASSES.keys.include? type.upcase.to_sym
  end
end

class Converter
  attr_reader :resource

  class InvalidResourceError < StandardError; end

  TYPE_ATTRIBUTES = {
    A:      %i(address ttl),
    AAAA:   %i(address ttl),
    CNAME:  %i(name ttl),
    MX:     %i(exchange preference ttl),
    NS:     %i(name ttl),
    SOA:    %i(expire minimum mname refresh retry rname serial ttl),
    TXT:    %i(strings ttl)
  }.freeze

  def initialize(resource)
    raise InvalidResourceError unless valid_resource?(resource)
    @resource = resource
  end

  def valid_resource?(resource)
    resource.class.ancestors.include? Resolv::DNS::Resource
  end

  def to_hash
    type = resource.class.to_s.split("::").last
    attributes = TYPE_ATTRIBUTES[type.to_sym]
    {}.tap do |hash|
      attributes.each do |attr|
        hash[attr] = resource.public_send(attr).to_s if resource.respond_to?(attr)
      end
    end
  end

  def self.to_hash(resource)
    new(resource).to_hash
  end
end
