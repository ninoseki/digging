# frozen_string_literal: true

describe Digger do
  describe "#get_resource" do
    it "should return a Resolv::DNS::Resource::IN::A object" do
      digger = Digger.new("google.com", "A", "8.8.8.8")
      resource = digger.get_resource
      expect(resource).to be_a Resolv::DNS::Resource::IN::A
    end

    it "should return a Resolv::DNS::Resource::IN::AAAA object" do
      digger = Digger.new("google.com", "AAAA", "8.8.8.8")
      resource = digger.get_resource
      expect(resource).to be_a Resolv::DNS::Resource::IN::AAAA
    end

    it "should return a Resolv::DNS::Resource::IN::CNAME object" do
      digger = Digger.new("mail.google.com", "CNAME", "8.8.8.8")
      resource = digger.get_resource
      expect(resource).to be_a Resolv::DNS::Resource::IN::CNAME
    end

    it "should return a Resolv::DNS::Resource::IN::MX object" do
      digger = Digger.new("google.com", "MX", "8.8.8.8")
      resource = digger.get_resource
      expect(resource).to be_a Resolv::DNS::Resource::IN::MX
    end

    it "should return a Resolv::DNS::Resource::IN::NS object" do
      digger = Digger.new("google.com", "NS", "8.8.8.8")
      resource = digger.get_resource
      expect(resource).to be_a Resolv::DNS::Resource::IN::NS
    end

    it "should return a Resolv::DNS::Resource::IN::SOA object" do
      digger = Digger.new("google.com", "SOA", "8.8.8.8")
      resource = digger.get_resource
      expect(resource).to be_a Resolv::DNS::Resource::IN::SOA
    end

    it "should return a Resolv::DNS::Resource::IN::TXT object" do
      digger = Digger.new("google.com", "TXT", "8.8.8.8")
      resource = digger.get_resource
      expect(resource).to be_a Resolv::DNS::Resource::IN::TXT
    end
  end

  describe "#initialize" do
    context "when given an invalid type" do
      it "should raise InvalidTypeError" do
        expect { Digger.new("github.com", "ERROR", "8.8.8.8") }.to raise_error(Digger::InvalidTypeError)
      end
    end
  end
end
