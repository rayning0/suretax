[![Code Climate](https://codeclimate.com/github/bqsoft/suretax.png)](https://codeclimate.com/github/bqsoft/suretax)
[![TravisCI](https://api.travis-ci.org/bqsoft/suretax.png)](https://travis-ci.org/bqsoft/suretax)
# Suretax


## Synopsis

```ruby
Suretax.configure do |c|
  c.validation_key  = ENV['SURETAX_VALIDATION_KEY']
  c.base_url        = ENV['SURETAX_BASE_URL']
  c.client_number   = ENV['SURETAX_CLIENT_NUMBER']
  c.request_version = ENV['SURETAX_REQUEST_VERSION']
  c.cancel_version  = ENV['SURETAX_CANCEL_VERSION']
end

request = Suretax::Api::Request.new({ initial: data })
request.items = [ Suretax::Api::RequestItem.new({ initial: data }) ]
connection = Suretax::Connection.new

if request.valid?
  response = connection.post(body: request.params)
  response.params
end
```

The configuration object is used to provide default values for
Suretax transactions.  The validation_key, client_number, and
base_url may be overridden by supplying the key when instantiating
a Suretax::Api::Request object.


If not supplied, the base_url will default to the Suretax test 
host (https://testapi.taxrating.net) and the request version
and cancel version will default to the latest versions available
(currently V03 and V01 respectively).


You can peek inside the tests for more examples and to see what data
methods are available.


## Development Environment

Suretax uses [dotenv] to easily switch between development/test environments
and production.

You will need to set the following environment variables for the gem to work:

- `SURETAX_VALIDATION_KEY` (You can get this from [SureTax][suretax].)
- `SURETAX_BASE_URL` (This is usually `https://testapi.taxrating.net` for testing.)

You can do this by creating a .env file in the root of the Suretax gem
repository (gitignored by default). For more information, please see
the [dotenv documentation][dotenv]

[dotenv]: https://github.com/bkeepers/dotenv
[suretax]: http://suretax.com
