require 'suretax'
require "excon"
require "money"
require "monetize"
require_relative '../suretax_input_params.rb'
require 'dotenv/load'
require 'awesome_print'
require 'pp'

class Tax
  include SureTaxInputParams

  def initialize(args)
    puts "\n\nSureTax input: #{args}"

    Suretax.configure do |c|
      c.validation_key  = ENV['SURETAX_VALIDATION_KEY']
      c.base_url        = ENV['SURETAX_BASE_URL']
      c.client_number   = ENV['SURETAX_CLIENT_NUMBER']
      c.request_version = ENV['SURETAX_REQUEST_VERSION']
      c.cancel_version  = ENV['SURETAX_CANCEL_VERSION']
    end

    @zipcode = args[:zipcode] || '91324'
    @trans_date = args[:trans_date] || '09/05/2017'
    @trans_type_code = args[:trans_type_code] || 'HWCREDIT'
    @tax_situs_rule = args[:tax_situs_rule] || '04'
    @seconds = args[:seconds] || '0'
    @regulatory_code = args[:regulatory_code] || '03'
    @sales_type_code = args[:sales_type_code] || 'R'
    @revenue = args[:revenue] || '40.00'
    @total_revenue = args[:total_revenue] || '40.00'
    @bill_to_number = args[:bill_to_number] || '8585260000'
    @orig_number = args[:orig_number] || '8585260000'
    @term_number = args[:term_number] || '8585260000'
    @units = args[:units] || '1'

    puts
    pp self
  end

  def get_taxes
    request = Suretax::Api::Request.new(suretax_valid_request_params)
    request.items = [ Suretax::Api::RequestItem.new(suretax_item_params) ]
    connection = Suretax::Connection.new

    if request.valid?
      response = connection.post(request.params)
      response.body
    end
  end
end
