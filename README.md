#Get tax info from SureTax API

In your directory, you must have secret `.env` file like this:
```
SURETAX_VALIDATION_KEY=____
SURETAX_CLIENT_NUMBER=____
SURETAX_BASE_URL=https://testapi.taxrating.net
SURETAX_REQUEST_VERSION=04
SURETAX_CANCEL_VERSION=01
```
##To Use:
```ruby
Tax.new(trans_type_code: 'FIXEDVOIP').get_taxes
```

Must put in at least 1 parameter. Must have 1-13 parameters, like:

```ruby
Tax.new(zipcode: '91311', revenue: '50.00', trans_type_code: 'HWCREDIT',...).get_taxes
```
For parameters you don't input, we use these defaults:

```ruby

 bill_to_number = "8585260000",
 orig_number = "8585260000",
 regulatory_code = "03",
 revenue = "40.00",
 sales_type_code = "R",
 seconds = "0",
 tax_situs_rule = "04",
 term_number = "8585260000",
 total_revenue = "40.00",
 trans_date = "09/05/2017",
 trans_type_code = "HWCREDIT",
 units = "1",
 zipcode = "91324"
```

See [software tests](https://github.com/xbpio/get_tax/spec/get_tax_spec.rb). See [sample API call results](https://github.com/xbpio/get_tax/sample_results.rb).

See [SureTax API call document](https://confluence.qualityspeaks.com/display/DEVPROCEDURES/SureTax+API+Call), plus

See p. 5-7 in [CCH SureTax Web Request API PDF](https://confluence.qualityspeaks.com/display/DEVPROCEDURES/SureTax+API+Call?preview=/16551209/16551210/CCH%20SureTax%20-%20Web%20Request%20API_v2.2.2%20(2)%20(1).pdf) for details on the 13 possible input parameters.
