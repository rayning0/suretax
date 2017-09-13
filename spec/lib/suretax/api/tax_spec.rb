require "spec_helper"

describe Suretax::Api::Tax do
  let(:tax) { Suretax::Api::Tax.new(tax_params) }

  context "with an API v01 response" do
    let(:tax_params) { valid_test_response_body["GroupList"].first["TaxList"].first }

    it "should have a code" do
      expect(tax.code).to eql("106")
    end

    it "should have a description" do
      expect(tax.description).to eql("CA EMERG TEL. USERS SURCHARGE")
    end

    it "should have an amount" do
      expect(tax.amount.to_f).to eql(0.200760)
    end
  end

  context "with an API v03 response" do
    let(:tax_params) { valid_v03_response_body["GroupList"].first["TaxList"].first }

    it "should have a code" do
      expect(tax.code).to eql("106")
    end

    it "should have a description" do
      expect(tax.description).to eql("CA EMERG TEL. USERS SURCHARGE")
    end

    it "should have an amount" do
      expect(tax.amount.to_f).to eql(0.200760)
    end

    it "should have a revenue code" do
      expect(tax.revenue).to eql("40")
    end

    it "should have a county name" do
      expect(tax.county).to eql("SAN DIEGO")
    end

    it "should have a city name" do
      expect(tax.city).to eql("SAN DIEGO")
    end

    it "should have a tax rate" do
      expect(tax.rate.to_f).to eql(0.005)
    end

    it "should have a percent taxable" do
      expect(tax.taxable.to_f).to eql(1.0)
    end

    it "should have a fee rate" do
      expect(tax.fee_rate.to_f).to eql 0.0
    end

    it "should have a tax on tax" do
      expect(tax.tax_on_tax.to_f).to eql 0.5
    end

    it "should have a revenue base" do
      expect(tax.revenue_base.to_f).to eql 40.0
    end
  end
end
