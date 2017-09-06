module Suretax
  module Api
    class Group
      attr_reader :state, :customer, :invoice, :taxes, :line

      def initialize(response_params)
        @state = response_params.fetch("StateCode")
        @invoice = response_params.fetch("InvoiceNumber")
        @line = response_params["LineNumber"]
        @customer = response_params.fetch("CustomerNumber")
        @taxes = response_params.fetch("TaxList").map { |tax| Tax.new(tax) }
      end
    end
  end
end
