# Get tax info from SureTax API

This gem is for XBP only. It's NOT the public "[suretax](https://github.com/Hello-Labs/suretax)" gem.

In Docker, Suretax's ENV variables are set in ap/config/initializers/suretax.rb.

If not in Docker, set environment vars with [direnv](https://direnv.net/) (`brew install direnv`):

In your directory, have secret `.envrc` file like:
```
export SURETAX_VALIDATION_KEY=____
export SURETAX_CLIENT_NUMBER=____
export SURETAX_BASE_URL=https://testapi.taxrating.net
export SURETAX_REQUEST_VERSION=04
export SURETAX_CANCEL_VERSION=01
```
## To Use:

In Gemfile, put
```ruby
gem 'suretax', git: 'https://github.com/rayning0/suretax.git'
```
In your code, put
```ruby
require 'suretax'

Tax.new(zipcode: '94088').get_tax
Tax.new(zipcode: '94088', revenue: '15.15').get_tax
Tax.new(zipcode: '94088', revenue: '15.15',
        trans_date: '09/12/2017', trans_type_code: 'FIXEDVOIP').get_tax
```

Must have at least 1 parameter. May have 1-13 parameters, like:

```ruby
Tax.new(trans_type_code: 'HWCREDIT', tax_situs_rule: '03', sales_type_code: 'B',...).get_tax
```
For parameters you leave out, we use these defaults from [default_args](https://github.com/rayning0/suretax/blob/master/lib/suretax/get_tax.rb):

```ruby
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
```

See [software tests](https://github.com/rayning0/suretax/blob/master/spec/get_tax_spec.rb). See [sample API requests/responses](https://github.com/rayning0/suretax/blob/master/spec/support/request_helper.rb).

See p. 5-7 in [CCH SureTax Web Request API PDF](https://github.com/rayning0/suretax/blob/master/CCH%20SureTax%20-%20Web%20Request%20API_v2.2.2.pdf) for details on the 13 possible input parameters.
