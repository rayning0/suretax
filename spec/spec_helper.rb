require "rspec"
require "rspec/its"
require "webmock/rspec"
require 'logger'
require 'pp'

# Load support files
Dir[File.expand_path(File.dirname(__FILE__) + "/support/**/*.rb")].each do |support_file|
  require support_file
end

RSpec.configure do |config|
  config.color = true
  config.before(:each) do
    Suretax.configure do |c|
      c.validation_key  = ENV["SURETAX_VALIDATION_KEY"]
      c.client_number   = ENV["SURETAX_CLIENT_NUMBER"]
      c.logger = Logger.new(STDOUT)
    end
  end

  config.expect_with :rspec do |c|
    c.syntax = %i[should expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = %i[should expect]
  end
end

# Silence deprecation warning from money/monetize libraries
I18n.enforce_available_locales = false

include RequestSpecHelper
include CancellationSpecHelper
include SuretaxSpecHelper
