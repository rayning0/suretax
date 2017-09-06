# See p. 5-7 in CCH SureTax Web Request API PDF for details on each item

module SureTaxInputParams
  def suretax_valid_request_params
    {
      total_revenue: @total_revenue,
      business_unit: "bizUnit",
      client_number: ENV["SURETAX_CLIENT_NUMBER"],
      client_tracking: "track",
      data_month: @trans_date.split('/').first,
      data_year: @trans_date.split('/').last,
      industry_exemption: "",
      response_group: "03",
      response_type: "D6",
      return_file_code: "Q",
      validation_key: ENV["SURETAX_VALIDATION_KEY"],
      items: [suretax_item_params]
    }
  end

  def suretax_item_params
    {
      zipcode: @zipcode,
      trans_date: @trans_date, # get data_month, data_year from this
      trans_type_code: @trans_type_code,
      tax_situs_rule: @tax_situs_rule,
      seconds: @seconds, # call duration
      regulatory_code: @regulatory_code,
      sales_type_code: @sales_type_code,
      revenue: @revenue,
      bill_to_number: @bill_to_number, # Required when using Tax Situs Rule 01 or 02
      orig_number: @orig_number, # Required when using Tax Situs Rule 01 or 03
      term_number: @term_number, # Required when using Tax Situs Rule 01
      units: @units,
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
