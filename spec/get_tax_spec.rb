require 'rspec'
require_relative '../lib/get_tax'

describe Tax do
  context '#get_taxes' do
    it 'initializes object with right defaults' do
      input = Tax.new(zipcode: '91311', trans_date: '08/30/2017')

      expect(input.inspect.split.drop(1).join).to eq("@zipcode=\"91311\",@trans_date=\"08/30/2017\",@trans_type_code=\"HWCREDIT\",@tax_situs_rule=\"04\",@seconds=\"0\",@regulatory_code=\"03\",@sales_type_code=\"R\",@revenue=\"40.00\",@total_revenue=\"40.00\",@bill_to_number=\"8585260000\",@orig_number=\"8585260000\",@term_number=\"8585260000\",@units=\"1\">")
    end

    it 'finds sales taxes' do
      res = Tax.new(zipcode: '91311').get_taxes

      expect(res['Successful']).to eq 'Y'
      expect(res['GroupList'][0]['TaxList'].map{ |tax| tax['TaxTypeDesc'] }).to eq([
        'STATE SALES TAX', 'COUNTY SALES TAX', 'DISTRICT TAX (LACT) (LATC ) (LAMT) (LAMA)'
      ])
    end

    it 'finds utility taxes' do
      res = Tax.new(trans_type_code: 'FIXEDVOIP').get_taxes

      expect(res['GroupList'][0]['TaxList'].map{ |tax| tax['TaxTypeDesc'] }).to eq([
        "CA EMERG TEL. USERS SURCHARGE",
        "CA TELECOM RELAY SYSTEMS SURCHARGE",
        "LOCAL UTILITY USERS TAX",
        "CA TELECONNECT FUND",
        "CA HIGH COST FUND(A) SURCHARGE",
        "CA UNIVERSAL LIFELINE  SURCHARGE",
        "FEDERAL UNIVERSAL SERVICE FUND",
        "FEDERAL COST RECOVERY CHARGE"
      ])
    end
  end
end
