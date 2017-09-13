require "spec_helper"

describe Suretax::Api::RequestItem do
  let(:args) { suretax_valid_request_item_params }
  let(:subject) { Suretax::Api::RequestItem.new(args) }

  describe "#tax_exemption_codes" do
    it "should have two codes" do
      expect(subject.tax_exemption_codes.count).to eql(2)
    end
  end

  describe "#params" do
    {
      bill_to_number: "8585260000",
      customer_number: "000000007",
      invoice_number: "1",
      line_number: "1",
      orig_number: "8585260000",
      p_to_p_plus_four: "",
      p_to_p_zipcode: "",
      plus_four: "",
      regulatory_code: "99",
      revenue: "40",
      sales_type_code: "R",
      seconds: "55",
      tax_included_code: "0",
      tax_situs_rule: "01",
      term_number: "8585260000",
      trans_date: "2013-12-01T00:00:00",
      trans_type_code: "010101",
      unit_type: "00",
      units: "1",
      zipcode: "",
      user_defined_field: "",
      ship_from_zipcode: "",
      ship_from_plus_four: "",
      order_placement_zipcode: "",
      order_placement_plus_four: "",
      order_approval_zipcode: "",
      order_approval_plus_four: "",
      geocode: "",
      aux_revenue: "0.00",
      aux_revenue_type: "01",
      freight_on_board: "",
      ship_from_pob: "1",
      mail_order: "1",
      common_carrier: "1",
      origin_country_code: "",
      dest_country_code: ""
    }.each_pair do |key, value|
      it "##{key} should return the correct value" do
        subject.send("#{key}=", value)
        expect(subject.send(key)).to eql(value)
      end
    end
  end

  describe "#params" do
    let(:valid_params) do
      valid_encoded_test_request_body["ItemList"].first
    end

    it "should return a valid parameters hash" do
      expect(subject.params).to eql(valid_params)
    end
  end
end
