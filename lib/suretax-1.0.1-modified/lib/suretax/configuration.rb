require "singleton"

module Suretax
  class Configuration
    include Singleton

    REQUEST_VERSIONS = [1, 2, 3, 4].freeze
    CANCEL_VERSIONS  = [1].freeze

    attr_accessor :validation_key, :base_url, :client_number,
      :request_version, :cancel_version, :logger

    def initialize
      register_currencies
      @base_url        = test_host
      @request_version = REQUEST_VERSIONS.max
      @cancel_version  = CANCEL_VERSIONS.max
    end

    def test?
      base_url == test_host
    end

    def request_version=(version_number)
      version = version_number.to_i
      if REQUEST_VERSIONS.include?(version.to_i)
        @request_version = version
      else
        raise(ArgumentError, "version must be in #{REQUEST_VERSIONS.join(', ')}")
      end
      @request_path = nil
    end

    def cancel_version=(version_number)
      version = version_number.to_i
      if CANCEL_VERSIONS.include?(version)
        @cancel_version = version
      else
        raise(ArgumentError, "version must be in #{CANCEL_VERSIONS.join(', ')}")
      end
      @cancel_path = nil
    end

    def request_path
      @request_path ||=
        "/Services/V%02d/SureTax.asmx/PostRequest" % request_version
    end

    def cancel_path
      @cancel_path ||=
        "/Services/V%02d/SureTax.asmx/CancelPostRequest" % cancel_version
    end

    private

    def test_host
      "https://testapi.taxrating.net"
    end

    def register_currencies
      register_dollar_with_six_decimal_places
    end

    def register_dollar_with_six_decimal_places
      Money::Currency.register(
        priority: 1,
iso_code: "US6",
iso_numeric: "840",
name: "Dollar with six decimal places",
symbol: "$",
subunit: "Cent",
subunit_to_unit: 1_000_000,
symbol_first: true,
html_entity: "$",
decimal_mark: ".",
thousands_separator: ",",
symbolize_names: true
      )
    end
  end
end
