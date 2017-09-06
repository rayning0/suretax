module Suretax
  module Api
    #
    # Given a transaction ID, sends a request to cancel
    # that transaction to Suretax.
    #
    class CancelRequest
      attr_accessor :client_number, :validation_key, :transaction,
                    :client_tracking

      attr_reader   :response

      def initialize(options = {})
        self.client_number  = options.fetch(:client_number,
                                            configuration.client_number)
        self.validation_key = options.fetch(:validation_key,
                                            configuration.validation_key)

        options.each_pair do |key, value|
          send("#{key}=", value.to_s)
        end
      end

      def submit
        log_request
        suretax_response = connection.cancel(params)

        log_response(suretax_response)
        @response = Suretax::Api::Response.new(suretax_response.body)
      end

      def params
        {
          "ClientNumber"   => client_number,
          "ClientTracking" => client_tracking,
          "TransId"        => transaction,
          "ValidationKey"  => validation_key
        }
      end

      private

      def log_request
        logger.info "\nSureTax Cancellation sent:\n#{params.inspect}"
      end

      def log_response(response)
        logger.info("\nSureTax Cancellation resp:\n#{response.inspect}")
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
