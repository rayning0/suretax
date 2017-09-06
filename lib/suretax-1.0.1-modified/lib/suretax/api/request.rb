module Suretax
  module Api
    class ValidationError < StandardError; end

    class Request
      include Suretax::Concerns::Validatable

      attr_accessor :business_unit,
                    :client_number,
                    :client_tracking,
                    :data_month,
                    :data_year,
                    :industry_exemption,
                    :response_group,
                    :stan,
                    :response_type,
                    :return_file_code,
                    :total_revenue,
                    :validation_key,
                    :items

      attr_reader   :response

      validate :client_number,
               :business_unit,
               :validation_key,
               :data_year,
               :data_month,
               :total_revenue,
               :return_file_code,
               :client_tracking,
               :response_group,
               :response_type,
               :items

      def initialize(options = {})
        self.return_file_code = "0"
        self.client_number    = options.delete(:client_number)  || configuration.client_number
        self.validation_key   = options.delete(:validation_key) || configuration.validation_key

        default_data_date(options)

        options.each_pair do |key, value|
          send("#{key}=", value.to_s)
        end

        initialize_items(options)

        validate!
      end

      def submit
        if valid?
          log_request
          suretax_response = connection.post(params)
          @response = Suretax::Api::Response.new(suretax_response.body)
        else
          raise(ValidationError, errors.messages.join(", "))
        end
      end

      def valid?
        errors.none?
      end

      def rollback
        if response
          CancelRequest.new(transaction: response.transaction,
            client_number: client_number, validation_key: validation_key,
            client_tracking: client_tracking).submit
        end
      end

      def params
        {
          "ClientNumber"             => client_number,
          "BusinessUnit"             => business_unit || "",
          "ValidationKey"            => validation_key,
          "DataYear"                 => data_year,
          "DataMonth"                => data_month,
          "TotalRevenue"             => total_revenue.to_f,
          "ReturnFileCode"           => return_file_code,
          "ClientTracking"           => client_tracking || "",
          "IndustryExemption"        => industry_exemption,
          "ResponseType"             => response_type,
          "ResponseGroup"            => response_group,
          "STAN"                     => stan || "",
          "ItemList"                 => items.map(&:params)
        }
      end

      private

      def default_data_date(options)
        max_date = configuration.test? ? Date.today.prev_month : Date.today

        requested_date = begin
                           Date.new(options.delete(:data_year).to_i, options.delete(:data_month).to_i, 1)
                         rescue
                           max_date
                         end

        data_date = [requested_date, max_date].min

        self.data_month = data_date.strftime("%m")
        self.data_year  = data_date.strftime("%Y")
      end

      def initialize_items(options)
        self.items = []
        if options[:items].respond_to?(:each)
          options[:items].each do |item_args|
            items << RequestItem.new(item_args)
          end
        end
      end

      def log_request
        logger.info "\nSureTax Request sent:\n#{params.inspect}"
      end

      def logger
        configuration.logger
      end

      def configuration
        Suretax.configuration
      end

      def connection
        @connection ||= Connection.new
      end
    end
  end
end
