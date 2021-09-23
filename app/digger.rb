# frozen_string_literal: true

require "resolv"
require "ipaddr"

class Digger
  # @return [String]
  attr_reader :name

  # @return [Resolv::DNS::Resource]
  attr_reader :type

  # @return [Resolv::DNS]
  attr_reader :server

  class InvalidTypeError < StandardError; end

  TYPE_CLASSES = {
    A: Resolv::DNS::Resource::IN::A,
    AAAA: Resolv::DNS::Resource::IN::AAAA,
    CNAME: Resolv::DNS::Resource::IN::CNAME,
    MX: Resolv::DNS::Resource::IN::MX,
    NS: Resolv::DNS::Resource::IN::NS,
    SOA: Resolv::DNS::Resource::IN::SOA,
    TXT: Resolv::DNS::Resource::IN::TXT
  }.freeze

  #
  # Initialize
  #
  # @param [String] name
  # @param [String] type
  # @param [String, nil] server
  #
  def initialize(name, type, server)
    raise InvalidTypeError unless valid_type?(type)

    @name = name
    @type = TYPE_CLASSES[type.upcase.to_sym]

    server = "8.8.8.8" if server.nil?
    @server = Resolv::DNS.new(nameserver: [server])
  end

  #
  # Get resources
  #
  # @return [Array<Resolv::DNS::Resource>]
  #
  def resources
    server.getresources(name, type)
  end

  #
  # Validate type
  #
  # @param [String] type
  #
  # @return [Boolean]
  #
  def valid_type?(type)
    TYPE_CLASSES.key?(type.upcase.to_sym)
  end
end

class Converter
  attr_reader :resource

  class InvalidResourceError < StandardError; end

  TYPE_ATTRIBUTES = {
    A: %i[address ttl],
    AAAA: %i[address ttl],
    CNAME: %i[name ttl],
    MX: %i[exchange preference ttl],
    NS: %i[name ttl],
    SOA: %i[expire minimum mname refresh retry rname serial ttl],
    TXT: %i[strings ttl]
  }.freeze

  def initialize(resource)
    raise InvalidResourceError unless valid_resource?(resource)

    @resource = resource
  end

  #
  # Validate resource
  #
  # @param [Resolv::DNS::Resource] resource
  #
  # @return [Boolean]
  #
  def valid_resource?(resource)
    resource.class.ancestors.include? Resolv::DNS::Resource
  end

  #
  # Return hash
  #
  # @return [Hash]
  #
  def to_hash
    type = resource.class.to_s.split("::").last
    attributes = TYPE_ATTRIBUTES[type.to_sym]

    {}.tap do |hash|
      attributes.each do |attr|
        next unless resource.respond_to?(attr)

        value = resource.public_send(attr)

        # TXT's strings returns an array of strings so do not change it
        # Otherwise convert the value to a string
        unless value.is_a?(Array)
          value = value.to_s
        end

        hash[attr] = value
      end
    end
  end

  #
  # Convert resource to hash
  #
  # @param [Resolv::DNS::Resource] resource
  #
  # @return [Hash]
  #
  def self.to_hash(resource)
    new(resource).to_hash
  end
end
