# frozen_string_literal: true

describe Converter do
  let(:dns) { Resolv::DNS.new }

  describe ".to_hash" do
    context "when given an in valid resouce" do
      it "should raise InvalidResourceError" do
        expect { Converter.to_hash("invalid") }.to raise_error(Converter::InvalidResourceError)
      end
    end

    context "when given an valid resource" do
      it "should return a Hash" do
        resource = dns.getresource("google.com", Resolv::DNS::Resource::IN::A)
        hash = Converter.to_hash(resource)
        expect(hash[:address]).to be_a(String)
      end
    end
  end
end
