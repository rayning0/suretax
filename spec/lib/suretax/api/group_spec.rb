require "spec_helper"

describe Suretax::Api::Group do
  let(:group) { Suretax::Api::Group.new(group_hash) }

  context "with a v01 API response" do
    let(:group_hash) { valid_test_response_body["GroupList"].first }

    it "should have a state" do
      expect(group.state).to eql("CA")
    end

    it "should have an invoice number" do
      expect(group.invoice).to eql("1")
    end

    it "should have a customer number" do
      expect(group.customer).to eql("000000007")
    end

    it "should have a list of taxes" do
      expect(group.taxes.count).to eql(8)
    end
  end

  context "with a v03 API response" do
    let(:group_hash) { valid_v03_response_body["GroupList"].first }

    it "should have a state" do
      expect(group.state).to eql("CA")
    end

    it "should have an invoice number" do
      expect(group.invoice).to eql("1")
    end

    it "should have a line number" do
      expect(group.line).to eql("1")
    end

    it "should have a customer number" do
      expect(group.customer).to eql("000000007")
    end

    it "should have a list of taxes" do
      expect(group.taxes.count).to eql(8)
    end
  end

  context "with a v04 HWCREDIT API response" do
    let(:group_hash) { valid_v04_hwcredit_response_body["GroupList"].first }

    it "should have a state" do
      expect(group.state).to eql("CA")
    end

    it "should have an invoice number" do
      expect(group.invoice).to eql("1")
    end

    it "should have a line number" do
      expect(group.line).to eql("1")
    end

    it "should have a customer number" do
      expect(group.customer).to eql("000000001")
    end

    it "should have a list of taxes" do
      expect(group.taxes.count).to eql(3)
      expect(group.taxes.map { |tax| tax.description }).to eq [
        "STATE SALES TAX",
        "COUNTY SALES TAX",
        "DISTRICT TAX (LACT) (LATC ) (LAMT) (LAMA)"
      ]
    end
  end

  context "with a v04 FIXEDVOIP API response" do
    let(:group_hash) { valid_v04_fixedvoip_response_body["GroupList"].first }

    it "should have a state" do
      expect(group.state).to eql("CA")
    end

    it "should have an invoice number" do
      expect(group.invoice).to eql("1")
    end

    it "should have a line number" do
      expect(group.line).to eql("1")
    end

    it "should have a customer number" do
      expect(group.customer).to eql("000000001")
    end

    it "should have a list of taxes" do
      expect(group.taxes.count).to eql(8)
      expect(group.taxes.map { |tax| tax.description }).to eq [
        "CA EMERG TEL. USERS SURCHARGE",
        "CA TELECOM RELAY SYSTEMS SURCHARGE",
        "LOCAL UTILITY USERS TAX",
        "CA TELECONNECT FUND",
        "CA HIGH COST FUND(A) SURCHARGE",
        "CA UNIVERSAL LIFELINE  SURCHARGE",
        "FEDERAL UNIVERSAL SERVICE FUND",
        "FEDERAL COST RECOVERY CHARGE"
      ]
    end
  end
end
