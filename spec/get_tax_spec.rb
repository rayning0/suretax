require 'i18n'
require 'spec_helper'
require 'suretax'

describe Tax do
  context '#get_taxes' do
    it 'changes default request arguments' do
      tax = Tax.new(zipcode: '91311', trans_date: '08/30/2017')
      expect(tax.args[:zipcode]).to eq '91311'
      expect(tax.args[:trans_date]).to eq '08/30/2017'
    end

    it 'finds sales taxes' do
      stub_request(:post, "#{suretax_url}#{suretax_post_path}").
        with(body: /91324/).to_return(
        status: 200,
        body: suretax_wrap_response(valid_v04_hwcredit_response_body.to_json)
      )
      res = Tax.new(zipcode: '91324').get_tax
      expect(res['Successful']).to eq 'Y'
      expect(res['GroupList'][0]['TaxList'].map{ |tax| tax['TaxTypeDesc'] }).to eq([
        'STATE SALES TAX',
        'COUNTY SALES TAX',
        'DISTRICT TAX (LACT) (LATC ) (LAMT) (LAMA)'
      ])
      expect(res).to eq valid_v04_hwcredit_response_body
    end

    it 'finds utility taxes' do
      stub_request(:post, "#{suretax_url}#{suretax_post_path}").
        with(body: /FIXEDVOIP/).to_return(
        status: 200,
        body: suretax_wrap_response(valid_v04_fixedvoip_response_body.to_json)
      )
      res = Tax.new(trans_type_code: 'FIXEDVOIP').get_tax
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
      expect(res).to eq valid_v04_fixedvoip_response_body
    end
  end
end
