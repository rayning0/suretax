module Suretax
  module Api
    class ItemMessage
      attr_reader :line_number, :response_code, :message

      def initialize(response_params)
        @line_number = response_params.fetch("LineNumber")
        @response_code = response_params.fetch("ResponseCode")
        @message = response_params.fetch("Message")
      end
    end
  end
end
