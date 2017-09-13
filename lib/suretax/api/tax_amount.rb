require "monetize"

module Suretax
  module Api
    class Amount
      attr_reader :precision, :divisor

      def initialize(amount, currency = "US6")
        @amount = Monetize.parse(amount, currency)
        @precision = count_significant_decimal_places
        @divisor = @amount.currency.subunit_to_unit
      end

      def to_f
        @amount.to_f
      end

      def to_s
        @amount.to_s
      end

      def to_i
        @amount.cents
      end

      def cents
        (("%.2f" % to_f).to_f * 100).to_i
      end

      def params
        {
          amount: to_i,
          precision: precision,
          divisor: divisor
        }
      end

      private

      def count_significant_decimal_places
        @amount.currency.subunit_to_unit.to_s.scan(/0/).count
      end
    end
  end
end
