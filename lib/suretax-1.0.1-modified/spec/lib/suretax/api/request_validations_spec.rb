require "spec_helper"

describe "Suretax API Request Validations" do
  let(:request) do
    Suretax::Api::Request.new(suretax_valid_request_params)
  end

  describe "#items" do
    context "when valid" do
      it "shows errors" do
        expect(request.errors.any?).to eq false
      end
    end

    context "when invalid" do
      it "shows no errors" do
        item = Suretax::Api::RequestItem.new(suretax_valid_request_item_params)
        item.customer_number = "a" * 9
        item.regulatory_code = 11_111
        request.items = [item]

        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to \
          eq([%(Invalid items: ["Invalid customer_number: aaaaaaaaa, Invalid regulatory_code: 11111"])])
      end
    end
  end

  describe "#client_number" do
    context "when present" do
      it "can be ten characters or less" do
        request.client_number = "1234567890"
        expect(request.errors.any?).to eq false

        request.client_number = "12345678901"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid client_number: 12345678901)]
      end

      it "must be a number" do
        request.client_number = "1"
        expect(request.errors.any?).to eq false

        request.client_number = "abcdefghij"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid client_number: abcdefghij)]
      end
    end

    context "when absent" do
      it "should fail validation" do
        request.client_number = nil
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid client_number: nil)]
      end
    end
  end

  describe "#business_unit" do
    context "when present" do
      it "can be blank" do
        request.business_unit = nil
        expect(request.errors.any?).to eq false

        request.business_unit = ""
        expect(request.errors.any?).to eq false
      end

      it "can be 20 characters or less" do
        request.business_unit = "a" * 5
        expect(request.errors.any?).to eq false

        request.business_unit = "a" * 20
        expect(request.errors.any?).to eq false

        request.business_unit = "a" * 21
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid business_unit: #{'a' * 21})]
      end

      it "must be alphanumeric" do
        request.business_unit = "aa124"
        expect(request.errors.any?).to eq false

        request.business_unit = "a_34"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid business_unit: a_34)]
      end
    end

    context "when absent" do
      it "should pass validation" do
        request.business_unit = nil
        expect(request.errors.any?).to eq false
      end
    end
  end

  describe "#validation_key" do
    context "when present" do
      it "must be a maximum of 36 characters" do
        request.validation_key = "a" * 36
        expect(request.errors.any?).to eq false

        request.validation_key = "a" * 37
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid validation_key: #{'a' * 37})]
      end
    end

    context "when absent" do
      it "should fail validation" do
        request.validation_key = nil
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid validation_key: nil)]
      end
    end
  end

  describe "#data_year" do
    context "when present" do
      it "must be a number" do
        request.data_year = "b" * 4
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_year: #{'b' * 4})]

        request.data_year = "-" * 4
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_year: #{'-' * 4})]

        request.data_year = "2014"
        expect(request.errors.any?).to eq false
      end

      it "must be exactly four digits" do
        request.data_year = "2014"
        expect(request.errors.any?).to eq false

        request.data_year = "20120"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_year: 20120)]

        request.data_year = "201"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_year: 201)]
      end

      it "must be in the range 1990-2050" do
        request.data_year = "1989"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_year: 1989)]

        request.data_year = "2051"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_year: 2051)]
      end
    end

    context "when absent" do
      it "fails validation" do
        request.data_year = nil
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_year: nil)]
      end
    end
  end

  describe "#data_month" do
    context "when present" do
      it "must allow all valid month numbers" do
        (1..12).each do |month_number|
          request.data_month = month_number.to_s
          expect(request.errors.any?).to eq false

          request.data_month = "%02d" % month_number.to_s
          expect(request.errors.any?).to eq false
        end
      end

      it "must allow all valid month numbers with a preceding zero" do
        (1..12).each do |month_number|
          request.data_month = "%02d" % month_number.to_s
          expect(request.errors.any?).to eq false
        end
      end

      it "must not allow invalid months" do
        request.data_month = "13"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_month: 13)]
      end
    end

    context "when absent" do
      it "should fail validation" do
        request.data_month = nil
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid data_month: nil)]
      end
    end
  end

  describe "#total_revenue" do
    context "when present" do
      it "can only be digits and the minus symbol" do
        request.total_revenue = "abcdefghi.jklm"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid total_revenue: abcdefghi.jklm)]

        request.total_revenue = "+1234"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid total_revenue: +1234)]
      end

      it "can have up to four decimal places" do
        request.total_revenue = "123456789.1234"
        expect(request.errors.any?).to eq false

        request.total_revenue = "123456789.1"
        expect(request.errors.any?).to eq false
      end

      it "must not have more than four decimal places" do
        request.total_revenue = "123456789.12345"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid total_revenue: 123456789.12345)]
      end

      context "and when the value is positive" do
        it "should have no symbol" do
          request.total_revenue = "+23456789.1234"
          expect(request.errors.any?).to eq true
          expect(request.errors.messages).to eq [%(Invalid total_revenue: +23456789.1234)]
        end

        it "can have up to nine positions to the left of the decimal" do
          request.total_revenue = "123456789.1234"
          expect(request.errors.any?).to eq false

          request.total_revenue = "1.1234"
          expect(request.errors.any?).to eq false

          request.total_revenue = "1234567890.1234"
          expect(request.errors.any?).to eq true
          expect(request.errors.messages).to eq [%(Invalid total_revenue: 1234567890.1234)]
        end

        it "can be a simple integer" do
          request.total_revenue = "1"
          expect(request.errors.any?).to eq false
        end
      end

      context "and when the value is negative" do
        it 'should have a "minus" symbol in the first position' do
          request.total_revenue = "-23456789.1234"
          expect(request.errors.any?).to eq false
        end

        it "must have nine positions to the left of the decimal" do
          request.total_revenue = "-23456789.1234"
          expect(request.errors.any?).to eq false
        end

        it "must not have more than nine positions to the left of the decimal" do
          request.total_revenue = "-234567890.1234"
          expect(request.errors.any?).to eq true
          expect(request.errors.messages).to eq [%(Invalid total_revenue: -234567890.1234)]
        end
      end
    end

    context "when absent" do
      it "should fail validation" do
        request.total_revenue = nil
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid total_revenue: nil)]
      end
    end
  end

  describe "#client_tracking" do
    context "when present" do
      it "must not be longer than 100 characters" do
        request.client_tracking = "a" * 101
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid client_tracking: #{'a' * 101})]
      end
    end

    context "when absent" do
      it "should pass validation" do
        request.client_tracking = nil
        expect(request.errors.any?).to eq false
      end
    end
  end

  describe "#return_file_code" do
    context "when present" do
      it "must be a valid code" do
        request.return_file_code = 0
        expect(request.errors.any?).to eq false

        request.return_file_code = "Q"
        expect(request.errors.any?).to eq false
      end

      it "cannot be any other value" do
        request.return_file_code = "a"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid return_file_code: a)]

        request.return_file_code = 1
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid return_file_code: 1)]

        request.return_file_code = "_"
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid return_file_code: _)]
      end
    end

    context "when absent" do
      it "should fail validation" do
        request.return_file_code = nil
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid return_file_code: nil)]
      end
    end
  end

  describe "#response_group" do
    context "when present" do
      it "must be a valid code" do
        %w[00 01 02 03].each do |code|
          request.response_group = code
          expect(request.errors.any?).to eq false
        end

        %w[a 04 _].each do |wrong_value|
          request.response_group = wrong_value
          expect(request.errors.any?).to eq true
          expect(request.errors.messages).to eq [%(Invalid response_group: #{wrong_value})]
        end
      end
    end

    context "when absent" do
      it "should fail validation" do
        request.response_group = nil
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid response_group: nil)]
      end
    end
  end

  describe "#response_type" do
    context "when present" do
      it "must be a valid code combination'" do
        %w[D1 D9 S1 S9].each do |type|
          request.response_type = type
          expect(request.errors.any?).to eq false
        end

        %w[a D0 S10 _].each do |bad_type|
          request.response_type = bad_type
          expect(request.errors.any?).to eq true
          expect(request.errors.messages).to eq [%(Invalid response_type: #{bad_type})]
        end
      end
    end

    context "when absent" do
      it "should fail validation" do
        request.response_type = nil
        expect(request.errors.any?).to eq true
        expect(request.errors.messages).to eq [%(Invalid response_type: nil)]
      end
    end
  end
end
