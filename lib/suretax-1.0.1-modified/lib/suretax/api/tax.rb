module Suretax
  module Api
    class Tax
      attr_reader :code, :description, :amount, :revenue, :county, :city, :rate, :taxable, :fee_rate, :tax_on_tax, :revenue_base

      def initialize(response_params)
        @code = response_params.fetch("TaxTypeCode")
        @description = response_params.fetch("TaxTypeDesc")
        @amount = set_amount(response_params.fetch("TaxAmount").to_f)
        @revenue = response_params["Revenue"]
        @county = response_params["CountyName"]
        @city = response_params["CityName"]
        @rate = set_amount(response_params["TaxRate"])
        @taxable = set_amount(response_params["PercentTaxable"])
        @fee_rate = set_amount(response_params["FeeRate"])
        @tax_on_tax = set_amount(response_params["TaxOnTax"])
        @revenue_base = set_amount(response_params["RevenueBase"])
      end

      private

      def set_amount(value)
        Amount.new(value) unless value.nil?
      end
    end
  end
end
