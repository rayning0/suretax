require "spec_helper"

describe Suretax::Connection do
  let(:connection) { Suretax::Connection.new }

  context "using v01 of the API" do
    describe "#post" do
      it_should_behave_like "API connection" do
        let(:api_path) { suretax_post_path }
        let(:request_body) { valid_encoded_test_request_body }
        let(:response) { connection.post(body: request_body) }

        let(:response_body) do
          suretax_wrap_response(valid_test_response_body.to_json)
        end

        let(:invalid_response_body) do
          suretax_wrap_response(post_failed_response_body.to_json)
        end
      end
    end

    describe "#cancel" do
      it_should_behave_like "API connection" do
        let(:api_path) { suretax_cancel_path }
        let(:request_body) { cancel_request_body }
        let(:response) { connection.cancel(body: request_body) }

        let(:response_body) do
          suretax_wrap_response(cancel_response_body.to_json)
        end

        let(:invalid_response_body) do
          suretax_wrap_response(cancel_failed_response_body.to_json)
        end
      end
    end
  end

  context "using v03 of the API" do
    describe "#post" do
      it_should_behave_like "API connection" do
        let(:api_path) { suretax_post_path }
        let(:request_body) { valid_encoded_test_request_body }
        let(:response) { connection.post(body: request_body) }

        let(:response_body) do
          suretax_wrap_response(valid_v03_response_body.to_json)
        end

        let(:invalid_response_body) do
          suretax_wrap_response(post_failed_response_body.to_json)
        end
      end
    end

    describe "#cancel" do
      it_should_behave_like "API connection" do
        let(:api_path) { suretax_cancel_path }
        let(:request_body) { cancel_request_body }
        let(:response) { connection.cancel(body: request_body) }

        let(:response_body) do
          suretax_wrap_response(cancel_response_body.to_json)
        end

        let(:invalid_response_body) do
          suretax_wrap_response(cancel_failed_response_body.to_json)
        end
      end
    end
  end
end
