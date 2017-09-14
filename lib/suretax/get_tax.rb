# See p. 5-7 in CCH SureTax Web Request API PDF for details on each item

require 'suretax'
require "excon"
require "money"
require "monetize"

class Tax
  attr_accessor :args

  def initialize(args)
    puts "\n\nSureTax input: #{args}"
    # In Docker, Suretax's ENV variables are set in ap/config/initializers/suretax.rb

    @args = default_args.merge(args)
  end

  def get_tax
    request = Suretax::Api::Request.new(request_params(args))
    request.items = [Suretax::Api::RequestItem.new(item_params(args))]
    connection = Suretax::Connection.new

    if request.valid?
      response = connection.post(request.params)
      response.body
    end
  end

  private

  def default_args
    {
      zipcode: '91324',
      trans_date: '09/12/2017',
      trans_type_code: 'HWCREDIT',
      revenue: '40.0',
      total_revenue: '40.0',
      tax_situs_rule: '04',
      seconds: '0',
      regulatory_code: '03',
      sales_type_code: 'R',
      bill_to_number: '8585260000',
      orig_number: '8585260000',
      term_number: '8585260000',
      units: '1',

      business_unit: "bizUnit",
      client_tracking: "track",
      industry_exemption: "",
      response_group: "03",
      response_type: "D6",
      return_file_code: '0'
    }
  end

  def request_params(args)
    {
      total_revenue: args[:total_revenue],
      business_unit: args[:business_unit],
      client_number: ENV["SURETAX_CLIENT_NUMBER"],
      client_tracking: args[:client_tracking],
      data_month: args[:trans_date].split('/').first,
      data_year: args[:trans_date].split('/').last,
      industry_exemption: args[:industry_exemption],
      response_group: args[:response_group],
      response_type: args[:response_type],
      return_file_code: args[:return_file_code],
      validation_key: ENV["SURETAX_VALIDATION_KEY"],
      items: [item_params(args)]
    }
  end

  def item_params(args)
    {
      zipcode: args[:zipcode],
      trans_date: args[:trans_date],
      trans_type_code: args[:trans_type_code],
      tax_situs_rule: args[:tax_situs_rule],
      seconds: args[:seconds], # call duration
      regulatory_code: args[:regulatory_code],
      sales_type_code: args[:sales_type_code],
      revenue: args[:revenue],
      bill_to_number: args[:bill_to_number], # Required for Tax Situs Rule 01 or 02
      orig_number: args[:orig_number], # Required for Tax Situs Rule 01 or 03
      term_number: args[:term_number], # Required for Tax Situs Rule 01
      units: args[:units],
      customer_number: "000000001",
      invoice_number: "1",
      line_number: "1",
      p_to_p_plus_four: "",
      p_to_p_zipcode: "",
      plus_four: "",
      tax_included_code: "0",
      unit_type: "00",
      tax_exemption_codes: %w[00 00],
      aux_revenue: nil,
      aux_revenue_type: nil,
      ship_from_pob: nil,
      mail_order: nil,
      common_carrier: nil
    }
  end
end
