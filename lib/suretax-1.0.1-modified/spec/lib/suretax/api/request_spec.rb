require "spec_helper"

describe Suretax::Api::Request do
  let(:args) { suretax_valid_request_params }
  let(:api_request) { Suretax::Api::Request.new(args) }
  let(:valid_params) { valid_encoded_test_request_body }

  describe "accessors" do
    {
      business_unit: "testing",
       client_number: suretax_client_number,
       client_tracking: "track",
       data_month: "7",
       data_year: "2013",
       industry_exemption: "",
       response_group: "03",
       response_type: "D6",
       stan: "11111",
       return_file_code: "0",
       total_revenue: "40",
       validation_key: suretax_key
    }.each_pair do |key, value|

      it "##{key} should return the correct value" do
        api_request.send("#{key}=", value)
        expect(api_request.send(key)).to eql(value)
      end
    end
  end

  context "configuration" do
    it "should use Suretax.configuration by default" do
      req = Suretax::Api::Request.new
      expect(req.client_number).to eql(suretax_client_number)
    end

    it "should allow the default configuration to be overridden" do
      client_number = "1122334455"

      req = Suretax::Api::Request.new(client_number: client_number)

      expect(req.client_number).to eql(client_number)
    end
  end

  context "defaults" do
    describe "#client_number" do
      it "should have :client_number set to the configuration default" do
        req = Suretax::Api::Request.new
        expect(req.client_number).to eql(suretax_client_number)
      end

      it "should allow you to override the default" do
        client_no = "9911991199"
        req = Suretax::Api::Request.new(client_number: client_no)
        expect(req.client_number).to eql(client_no)
      end
    end

    describe "#validation_key" do
      it "should have :validation_key set to the configuration default" do
        req = Suretax::Api::Request.new
        expect(req.validation_key).to eql(suretax_key)
      end

      it "should allow you to override the default" do
        key = "9911991199-abdce-000000000"
        req = Suretax::Api::Request.new(validation_key: key)
        expect(req.validation_key).to eql(key)
      end
    end

    describe "#return_file_code" do
      it 'should have :return_file_code set to "0"' do
        req = Suretax::Api::Request.new
        expect(req.return_file_code).to eql("0")
      end

      it "should allow you to override the default" do
        req = Suretax::Api::Request.new(return_file_code: "Q")
        expect(req.return_file_code).to eql("Q")
      end
    end
  end

  describe "#params" do
    it "should return a valid parameters hash" do
      expect(api_request.params).to eql(valid_params)
    end
  end

  describe "#submit" do
    subject { api_request.submit }
    let(:api_path) { suretax_post_path }

    before(:each) do
      stub_request(:post, "#{suretax_url}#{api_path}").to_return(
        status: 200,
        body: suretax_wrap_response(valid_test_response_body.to_json)
      )
    end

    it "should return a Suretax::Api::Response" do
      should be_a_kind_of(Suretax::Api::Response)
    end

    its("groups.size") { should >= 1 }

    it "should have taxes" do
      subject.groups.map(&:taxes).should_not be_empty
    end

    it "should have a transaction number" do
      subject.transaction.should_not be_nil
      subject.transaction.size.should_not be_zero
    end
  end

  describe "#rollback" do
    subject { api_request.rollback }

    context "before submitting the request" do
      before(:each) { api_request.send(:response).should be_nil }
      it { should be_nil }
    end

    context "after submitting the request" do
      before(:each) do
        stub_request(:post, "#{suretax_url}#{suretax_post_path}").to_return(
          status: 200,
          body: suretax_wrap_response(valid_test_response_body.to_json)
        )
        api_request.submit
      end

      it "should issue a cancel request" do
        Suretax::Api::CancelRequest.should_receive(:new).
          with(transaction:     api_request.response.transaction,
               client_number:   api_request.client_number,
               validation_key:  api_request.validation_key,
               client_tracking: api_request.client_tracking).
          and_return(double(Suretax::Api::CancelRequest, submit: true))
        subject
      end
    end
  end

  describe "#data_month" do
    subject { Suretax::Api::Request.new(options) }

    context "when the value is supplied" do
      let(:options) { { data_month: "04" } }
      its(:data_month) { should eql "04" }
    end

    context "when the value is not supplied" do
      let(:options) { {} }

      context "and Suretax is configured for production" do
        before(:each) { Suretax.configuration.stub(:test?).and_return(false) }
        its(:data_month) { should eql Date.today.strftime("%m") }
      end

      context "and Suretax is not configured for production" do
        before(:each) { Suretax.configuration.stub(:test?).and_return(true) }
        its(:data_month) { should eql Date.today.prev_month.strftime("%m") }
      end
    end
  end

  describe "#data_year" do
    subject { Suretax::Api::Request.new(options) }

    context "when the value is supplied" do
      let(:options) {  { data_year: "2012", data_month: "01" } }
      its(:data_year)  { should eql "2012" }
      its(:data_month) { should eql "01" }
    end

    context "when the value is not supplied" do
      before(:each) { Date.stub(:today) { Date.new(2014, 0o1, 0o1) } }
      let(:options) { {} }

      context "and Suretax is configured for production" do
        before(:each) { Suretax.configuration.stub(:test?).and_return(false) }
        its(:data_year) { should eql Date.today.strftime("%Y") }
      end

      context "and Suretax is not configured for production" do
        before(:each) { Suretax.configuration.stub(:test?).and_return(true) }
        its(:data_year) { should eql Date.today.prev_month.strftime("%Y") }
      end
    end
  end
end
