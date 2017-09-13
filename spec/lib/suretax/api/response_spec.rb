require "spec_helper"

describe Suretax::Api::Response do
  let(:api_response) { Suretax::Api::Response.new(response_body) }

  context "for a normal post request" do
    context "with a successful response" do
      let(:response_body) { valid_test_response_body }

      it "should return the API status code" do
        expect(api_response.status).to eql("9999")
      end

      it "should be successful" do
        expect(api_response).to be_success
      end

      it "should not have item errors" do
        expect(api_response).not_to be_item_errors
      end

      it 'should have a message of "Success"' do
        expect(api_response.message).to eql("Success")
      end

      it "should have the correct total tax" do
        expect(api_response.total_tax.to_f).to eql(1.394490)
      end

      it "should have a transaction id" do
        expect(api_response.transaction).to eql("2664495")
      end

      context "invoice groups" do
        it "should be the correct number" do
          expect(api_response.groups.count).to eql(1)
        end

        it "should respond to #invoice" do
          expect(api_response.groups.first).to respond_to(:invoice)
        end
      end
    end

    context "with a partially successful response" do
      let(:response_body) { success_with_item_errors }

      describe "#status" do
        it "should return the API status code" do
          expect(api_response.status).to eql("9001")
        end
      end

      describe "#success?" do
        it "should be true" do
          expect(api_response).to be_success
        end
      end

      describe "#item_errors?" do
        it "should be true" do
          expect(api_response).to be_item_errors
        end
      end

      describe "#item_messages" do
        it "should be the correct number" do
          expect(api_response.item_messages.size).to eql(1)
        end

        it "should response to #message" do
          expect(api_response.item_messages.first).to respond_to(:message)
        end
      end

      describe "#message" do
        it 'should start with "Failure"' do
          expect(api_response.message).to match(/\ASuccess with item errors/i)
        end
      end
    end

    context "with a failure response" do
      let(:response_body) { post_failed_response_body }

      describe "#status" do
        it "should return the API status code" do
          expect(api_response.status).to eql("1101")
        end
      end

      describe "#success?" do
        it "should be false" do
          expect(api_response.success?).to eql false
        end
      end

      describe "#item_errors?" do
        it "should be false" do
          expect(api_response).not_to be_item_errors
        end
      end

      describe "#message" do
        it 'should start with "Failure"' do
          expect(api_response.message).to match(/\AFailure/)
        end
      end
    end
  end

  context "for a cancel post request" do
    context "with a successful response" do
      let(:response_body) { cancel_response_body }

      it "should return the API status code" do
        expect(api_response.status).to eql("9999")
      end

      it "should be successful" do
        expect(api_response).to be_success
      end

      it 'should have a message of "Success"' do
        expect(api_response.message).to eql("Success")
      end

      it "should have a transaction id" do
        expect(api_response.transaction).to eql("0")
      end

      it "should have the client tracking code set" do
        expect(api_response.client_tracking).to eql("test")
      end
    end

    context "with a failed request" do
      let(:response_body) { cancel_failed_response_body }

      it "should return the API status code" do
        expect(api_response.status).to be_nil
      end

      it "should be successful" do
        expect(api_response).to_not be_success
      end

      it 'should have a message of "Success"' do
        expect(api_response.message).to be_nil
      end

      it "should have a transaction id" do
        expect(api_response.transaction).to eql("0")
      end

      it "should have the client tracking code set" do
        expect(api_response.client_tracking).to be_nil
      end
    end
  end
end
