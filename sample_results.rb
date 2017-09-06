In my .env file I use:
SURETAX_REQUEST_VERSION=04
So API URL is https://testapi.taxrating.net/Services/V04/SureTax.asmx/

  def suretax_valid_request_params
    {
      business_unit: "bizUnit",
      client_number: suretax_client_number,
      client_tracking: "track",
      data_month: "8",
      data_year: "2017",
      industry_exemption: "",
      response_group: "03",
      response_type: "D6",
      return_file_code: "Q",
      total_revenue: "40",
      validation_key: suretax_key,
      items: [suretax_valid_request_item_params]
    }
  end

  def suretax_valid_request_item_params
    {
      bill_to_number: "8585260000",
      customer_number: "000000001",
      invoice_number: "1",
      line_number: "1",
      orig_number: "8585260000",
      p_to_p_plus_four: "",
      p_to_p_zipcode: "",
      plus_four: "",
      regulatory_code: "03",
      revenue: "40",
      sales_type_code: "R",
      seconds: "0",
      tax_included_code: "0",
      tax_situs_rule: "04",
      term_number: "8585260000",
      trans_date: "2017-08-30T00:00:00",
      trans_type_code: "990101",
      unit_type: "00",
      units: "1",
      zipcode: "91311",
      tax_exemption_codes: %w[00 00],
      aux_revenue: nil,
      aux_revenue_type: nil,
      ship_from_pob: nil,
      mail_order: nil,
      common_carrier: nil
    }
  end

  SureTax Response Received:
=> {"Successful"=>"Y",
 "ResponseCode"=>"9999",
 "HeaderMessage"=>"Success",
 "ItemMessages"=>[],
 "ClientTracking"=>"track",
 "TotalTax"=>"3.700000",
 "TransId"=>542918615,
 "STAN"=>"",
 "GroupList"=>
  [{"LineNumber"=>"1",
    "StateCode"=>"CA",
    "InvoiceNumber"=>"1",
    "CustomerNumber"=>"000000001",
    "TaxList"=>
     [{"TaxTypeCode"=>"101",
       "TaxTypeDesc"=>"STATE SALES TAX",
       "TaxAmount"=>"2.400000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.06,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"},
      {"TaxTypeCode"=>"202",
       "TaxTypeDesc"=>"COUNTY SALES TAX",
       "TaxAmount"=>"0.500000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.0125,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"},
      {"TaxTypeCode"=>"203",
       "TaxTypeDesc"=>"DISTRICT TAX (LACT) (LATC ) (LAMT) (LAMA)",
       "TaxAmount"=>"0.800000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.02,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"}]}]}

For "VOIPEQUIP" (110402) we get:

{"Successful"=>"Y",
 "ResponseCode"=>"9999",
 "HeaderMessage"=>"Success",
 "ItemMessages"=>[],
 "ClientTracking"=>"track",
 "TotalTax"=>"3.700000",
 "TransId"=>543068952,
 "STAN"=>"",
 "GroupList"=>
  [{"LineNumber"=>"1",
    "StateCode"=>"CA",
    "InvoiceNumber"=>"1",
    "CustomerNumber"=>"000000001",
    "TaxList"=>
     [{"TaxTypeCode"=>"101",
       "TaxTypeDesc"=>"STATE SALES TAX",
       "TaxAmount"=>"2.400000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.06,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"},
      {"TaxTypeCode"=>"202",
       "TaxTypeDesc"=>"COUNTY SALES TAX",
       "TaxAmount"=>"0.500000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.0125,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"},
      {"TaxTypeCode"=>"203",
       "TaxTypeDesc"=>"DISTRICT TAX (LACT) (LATC ) (LAMT) (LAMA)",
       "TaxAmount"=>"0.800000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.02,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"}]}]}

For "HWCREDIT" (990101), I get:

=> {"Successful"=>"Y",
 "ResponseCode"=>"9999",
 "HeaderMessage"=>"Success",
 "ItemMessages"=>[],
 "ClientTracking"=>"track",
 "TotalTax"=>"3.700000",
 "TransId"=>543069694,
 "STAN"=>"",
 "GroupList"=>
  [{"LineNumber"=>"1",
    "StateCode"=>"CA",
    "InvoiceNumber"=>"1",
    "CustomerNumber"=>"000000001",
    "TaxList"=>
     [{"TaxTypeCode"=>"101",
       "TaxTypeDesc"=>"STATE SALES TAX",
       "TaxAmount"=>"2.400000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.06,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"},
      {"TaxTypeCode"=>"202",
       "TaxTypeDesc"=>"COUNTY SALES TAX",
       "TaxAmount"=>"0.500000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.0125,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"},
      {"TaxTypeCode"=>"203",
       "TaxTypeDesc"=>"DISTRICT TAX (LACT) (LATC ) (LAMT) (LAMA)",
       "TaxAmount"=>"0.800000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.02,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"}]}]}

For 060102 - BROADBAND (for LA ZIP code, 91311) we get

{"Successful"=>"Y", "ResponseCode"=>"9999", "HeaderMessage"=>"Success", "ItemMessages"=>[], "ClientTracking"=>"track", "TotalTax"=>"0", "TransId"=>543070486, "STAN"=>"", "GroupList"=>[]}

For BROADBAND, with Texas ZIP code (77001) we get

=> {"Successful"=>"Y",
 "ResponseCode"=>"9999",
 "HeaderMessage"=>"Success",
 "ItemMessages"=>[],
 "ClientTracking"=>"track",
 "TotalTax"=>"2.900000",
 "TransId"=>542921735,
 "STAN"=>"",
 "GroupList"=>
  [{"LineNumber"=>"1",
    "StateCode"=>"TX",
    "InvoiceNumber"=>"1",
    "CustomerNumber"=>"000000001",
    "TaxList"=>
     [{"TaxTypeCode"=>"101",
       "TaxTypeDesc"=>"STATE SALES TAX",
       "TaxAmount"=>"2.500000",
       "Revenue"=>"40.0",
       "CountyName"=>"HARRIS",
       "CityName"=>"HOUSTON",
       "TaxRate"=>0.0625,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"},
      {"TaxTypeCode"=>"304",
       "TaxTypeDesc"=>"CITY SALES TAX",
       "TaxAmount"=>"0.400000",
       "Revenue"=>"40.0",
       "CountyName"=>"HARRIS",
       "CityName"=>"HOUSTON",
       "TaxRate"=>0.01,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0"},
      {"TaxTypeCode"=>"123",
       "TaxTypeDesc"=>"STATE COST-RECOVERY FEE",
       "TaxAmount"=>"0",
       "Revenue"=>"40.0",
       "CountyName"=>"HARRIS",
       "CityName"=>"HOUSTON",
       "TaxRate"=>0,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.0",
       "TaxOnTax"=>"0"}]}]}

For 050101 - FIXEDVOIP (in LA) we get

{"Successful"=>"Y",
 "ResponseCode"=>"9999",
 "HeaderMessage"=>"Success",
 "ItemMessages"=>[],
 "ClientTracking"=>"track",
 "TotalTax"=>"8.882172",
 "TransId"=>543071132,
 "STAN"=>"",
 "GroupList"=>
  [{"LineNumber"=>"1",
    "StateCode"=>"CA",
    "InvoiceNumber"=>"1",
    "CustomerNumber"=>"000000001",
    "TaxList"=>
     [{"TaxTypeCode"=>"106",
       "TaxTypeDesc"=>"CA EMERG TEL. USERS SURCHARGE",
       "TaxAmount"=>"0.300000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.0075,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0.000000"},
      {"TaxTypeCode"=>"109",
       "TaxTypeDesc"=>"CA TELECOM RELAY SYSTEMS SURCHARGE",
       "TaxAmount"=>"0.200000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.005,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0.000000"},
      {"TaxTypeCode"=>"316",
       "TaxTypeDesc"=>"LOCAL UTILITY USERS TAX",
       "TaxAmount"=>"4.011372",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.09,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"44.570800",
       "TaxOnTax"=>"0.411372"},
      {"TaxTypeCode"=>"118",
       "TaxTypeDesc"=>"CA TELECONNECT FUND",
       "TaxAmount"=>"0.432000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.0108,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0.000000"},
      {"TaxTypeCode"=>"119",
       "TaxTypeDesc"=>"CA HIGH COST FUND(A) SURCHARGE",
       "TaxAmount"=>"0.140000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.0035,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0.000000"},
      {"TaxTypeCode"=>"122",
       "TaxTypeDesc"=>"CA UNIVERSAL LIFELINE  SURCHARGE",
       "TaxAmount"=>"1.900000",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.0475,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0.000000"},
      {"TaxTypeCode"=>"035",
       "TaxTypeDesc"=>"FEDERAL UNIVERSAL SERVICE FUND",
       "TaxAmount"=>"0.983200",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.02458,
       "PercentTaxable"=>1,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0.000000"},
      {"TaxTypeCode"=>"060",
       "TaxTypeDesc"=>"FEDERAL COST RECOVERY CHARGE",
       "TaxAmount"=>"0.915600",
       "Revenue"=>"40.0",
       "CountyName"=>"LOS ANGELES",
       "CityName"=>"LOS ANGELES",
       "TaxRate"=>0.02289,
       "PercentTaxable"=>1.0,
       "FeeRate"=>0,
       "RevenueBase"=>"40.000000",
       "TaxOnTax"=>"0.000000"}]}]}