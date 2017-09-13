require "spec_helper"

describe Suretax::Response do
  let(:api_response_class) {
    Struct.new(:status, :body, :success) do
      def success?
        success
      end
    end
  }

  let(:status_code) { 200 }

  let(:api_response_object) {
    api_response_class.new(
      status_code,
      response_body,
      true
    )
  }

  let(:client_response) { Suretax::Response.new(api_response_object) }

  context "when posting is successful" do
    let(:response_body) do
      suretax_wrap_response(valid_test_response_body.to_json)
    end

    it "has a body" do
      expect(client_response.body).to be_instance_of(Hash)
    end

    it "has a status" do
      expect(client_response.status).to eql(200)
    end

    it "is successful" do
      expect(client_response).to be_success
    end

    it "has a response object" do
      client_response.response.should respond_to(:status, :body)
    end

    it "should return the correct response body" do
      expect(client_response.body["ResponseCode"]).to eql("9999")
      expect(client_response.body["TotalTax"]).to eql("1.394490")
    end
  end

  context "when posting is partially successful" do
    let(:response_body) do
      suretax_wrap_response(success_with_item_errors.to_json)
    end

    before do
      api_response_object.success = false
    end

    it "has a body" do
      expect(client_response.body).to be_instance_of(Hash)
    end

    it "responds with a 409" do
      expect(client_response.status).to eql(409)
    end

    it "is unsuccessful" do
      expect(client_response).to_not be_success
    end

    it "has a response object" do
      client_response.response.should respond_to(:status, :body)
    end

    it "should return the correct response body" do
      expect(client_response.body["ResponseCode"]).to eql("9001")
      expect(client_response.body["TotalTax"]).to eql("26.53")
    end
  end

  context "when posting fails" do
    let(:response_body) do
      suretax_wrap_response(post_failed_response_body.to_json)
    end

    before do
      api_response_object.success = false
    end

    it "has a body" do
      expect(client_response.body).to be_instance_of(Hash)
    end

    it "responds with a 400" do
      expect(client_response.status).to eql(400)
    end

    it "is unsuccessful" do
      expect(client_response).to_not be_success
    end

    it "has a response object" do
      client_response.response.should respond_to(:status, :body)
    end

    it "should return the correct response body" do
      expect(client_response.body["ResponseCode"]).to eql("1101")
      expect(client_response.body["TotalTax"]).to be_nil
    end
  end

  context "when posting fails from a malformed request" do
    let(:response_body) { suretax_wrap_response("invalid request") }

    before do
      api_response_object.success = true
    end

    it "has a body" do
      expect(client_response.body).to eql("invalid request")
    end

    it "responds with a 409" do
      expect(client_response.status).to eql(400)
    end

    it "is unsuccessful" do
      expect(client_response).to_not be_success
    end
  end
end
