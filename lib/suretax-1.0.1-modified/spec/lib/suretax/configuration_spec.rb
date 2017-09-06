require "spec_helper"

describe Suretax do
  let(:config) { Suretax.configuration }
  let(:url)         { "http://test.dev" }
  let(:test_host)   { "https://testapi.taxrating.net" }

  describe ".configure" do
    let(:key)         { "xxxxxxxx" }
    let(:client)      { "9999999999" }
    let(:post_path)   { "/Services/V04/SureTax.asmx/PostRequest" }
    let(:cancel_path) { "/Services/V01/SureTax.asmx/CancelPostRequest" }

    before do
      Suretax.configure do |c|
        c.validation_key = key
        c.client_number = client
        c.request_version = "04"
      end
    end

    it "should allow me to set the validation key" do
      expect(config.validation_key).to eql key
    end

    it "should allow me to set the API server base url" do
      expect(config.base_url).to eql test_host
    end

    it "should allow me to set the client number" do
      expect(config.client_number).to eql client
    end

    it "should allow me to set the default post path" do
      expect(config.request_path).to eql post_path
    end

    it "should allow me to set the default cancel path" do
      expect(config.cancel_path).to eql cancel_path
    end

    it "should default test mode" do
      expect(config.test?).to eql true
    end

    it "should allow me to set the request version" do
      expect(config.request_version).to eql 4
    end

    context "when setting the mode" do
      around(:each) do |test|
        original_url = Suretax.configuration.base_url
        Suretax.configuration.base_url = url
        test.run
        Suretax.configuration.base_url = original_url
      end

      it "should allow me to select non-test mode" do
        expect(config.test?).to eql false
      end
    end
  end

  describe "production?" do
    subject { Suretax.configuration.test? }

    context "when using the test host" do
      around(:each) do |test|
        original_url = Suretax.configuration.base_url
        Suretax.configuration.base_url = test_host
        test.run
        Suretax.configuration.base_url = original_url
      end
      it { should eql true }
    end

    context "when using another host" do
      around(:each) do |test|
        original_url = Suretax.configuration.base_url
        Suretax.configuration.base_url = url
        test.run
        Suretax.configuration.base_url = original_url
      end
      it { should eql false }
    end
  end

  describe "loading from the app environment" do
    it "should allow me to set the validation key" do
      expect(suretax_key).to_not match(/\A\s*\z/)
      expect(config.validation_key).to include(suretax_key)
    end

    it "should allow me to set the API server base url" do
      expect(suretax_url).to_not match(/\A\s*\z/)
      expect(config.base_url).to include(suretax_url)
    end
  end
end
