require "spec_helper"

shared_examples_for "API connection" do
  context "with a valid request" do
    before do
      stub_request(:post, "#{suretax_url}#{api_path}").to_return(
        status: 200,
        body: response_body
      )
    end

    it "should be successful" do
      expect(response).to be_success
    end

    it "should have a urlencode header" do
      expect(connection.headers["Content-Type"]).to include("application/x-www-form-urlencoded")
    end
  end

  context "with an invalid request" do
    let(:request_body) { {} }

    before do
      stub_request(:post, "#{suretax_url}#{api_path}").to_return(
        status: 500,
        body: invalid_response_body
      )
    end

    it "should not be successful" do
      expect(response).to_not be_success
    end
  end
end
