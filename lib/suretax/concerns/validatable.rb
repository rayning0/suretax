module Suretax::Concerns
  module Validatable
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, Validations)
    end

    def errors
      @errors = Errors.new

      self.class.validatable_attributes.each do |attribute_name|
        value = send(attribute_name)
        assertion = send("valid_#{attribute_name}?", value)

        @errors[attribute_name] = Error.new(attribute_name, value) unless assertion
      end

      @errors
    end
    alias validate! errors

    class Error
      attr_accessor :message, :value, :attribute

      def initialize(attribute, value)
        self.value     = value
        self.attribute = attribute
        self.message   = "Invalid #{attribute}: #{reason}"
      end

      private

      def reason
        nested_errors? ? format_nested_errors(value) : format_error(value)
      end

      def format_nested_errors(value)
        value.map { |obj| obj.errors.messages.join(", ") }
      end

      def format_error(value)
        if value.nil?
          "nil"
        elsif value.is_a?(String) && value.empty?
          %('')
        else
          value
        end
      end

      def nested_errors?
        value.respond_to?(:each) && value.all? { |obj| obj.respond_to?(:errors) }
      end
    end

    class Errors < Hash
      def messages
        map { |_key, value| value.message }
      end
    end

    module ClassMethods
      attr_writer :validatable_attributes

      def validate(*attribute_names)
        self.validatable_attributes = attribute_names
      end

      def validatable_attributes
        @validatable_attributes ||= []
      end
    end

    module Validations
      def valid_data_year?(value)
        return false if blank?(value)
        value.length == 4 &&
          (value.to_i <= 2050 && value.to_i >= 1990)
      end

      def valid_data_month?(value)
        matches?(value, month_list_subexpression)
      end

      def valid_items?(items)
        items.none? { |item| item.errors.any? }
      end

      def valid_list?(value)
        value.respond_to?(:each)
      end

      def valid_client_number?(value)
        return false if blank?(value)
        numeric?(value) && value.length <= 10
      end
      alias valid_customer_number? valid_client_number?

      def valid_business_unit?(value)
        blank?(value) || (value.length <= 20 && alphanumeric?(value))
      end

      def valid_validation_key?(value)
        return false if blank?(value)
        value.length <= 36
      end

      def valid_total_revenue?(value)
        matches?(value, total_revenue_positive_subexpression) ||
          matches?(value, total_revenue_negative_subexpression)
      end

      def valid_return_file_code?(value)
        matches?(value.to_s, "[Q0]")
      end

      def valid_client_tracking?(value)
        blank?(value) || value.length <= 100
      end

      def valid_response_group?(value)
        Suretax::RESPONSE_GROUPS.values.include?(value)
      end

      def valid_response_type?(value)
        matches?(value, "[DS][1-9]")
      end

      def valid_line_number?(value)
        blank?(value) || (value.length <= 20 && alphanumeric?(value))
      end

      def valid_invoice_number?(value)
        blank?(value) || (value.length <= 20 && alphanumeric?(value))
      end

      def valid_tax_situs_rule?(value)
        Suretax::TAX_SITUS_RULES.values.include?(value)
      end

      def valid_trans_type_code?(value)
        !blank?(value)
      end

      def valid_sales_type_code?(value)
        match_value = "[#{Suretax::SALES_TYPE_CODES.values.join}]"
        !blank?(value) && matches?(value, match_value)
      end

      def valid_regulatory_code?(value)
        !blank?(value) && Suretax::REGULATORY_CODES.values.include?(value)
      end

      def valid_tax_exemption_code_list?(value)
        valid_list?(value) && !blank?(value.first)
      end
      alias valid_tax_exemption_codes? valid_tax_exemption_code_list?

      def optional_north_american_phone_number?(value)
        blank?(value) || north_american_phone_number?(value)
      end
      alias valid_bill_to_number? optional_north_american_phone_number?
      alias valid_orig_number? optional_north_american_phone_number?
      alias valid_term_number? optional_north_american_phone_number?

      private

      def north_american_phone_number?(value)
        !blank?(value) && (value.length == 10 && numeric?(value))
      end

      def total_revenue_negative_subexpression
        '-\d{,8}(?:\.\d{,4})?'
      end

      def total_revenue_positive_subexpression
        '\d{,9}(?:\.\d{,4})?'
      end

      def numeric?(value)
        matches?(value, '\d+')
      end

      def alphanumeric?(value)
        matches?(value, "[a-z0-9]+")
      end

      def blank?(value)
        value.nil? || matches?(value, '\s*')
      end

      def matches?(value, subexpression)
        /\A#{subexpression}\z/i === value
      end

      # Month numbers 1-12 with optional leading zero
      def month_list_subexpression
        "0?(?:" + (1..12).to_a.join("|") + ")"
      end
    end
  end
end
