require File.join(File.dirname(__FILE__), "item_message.rb")

module Suretax
  module Api
    class Response
      attr_reader :status, :message, :total_tax, :groups, :transaction,
        :client_tracking, :item_messages, :body

      def initialize(response_body)
        @body = JSON.generate(response_body)
        @status = response_body.fetch("ResponseCode")
        @transaction = response_body.fetch("TransId").to_s
        @message = response_body.fetch("HeaderMessage")
        @success = response_body.fetch("Successful") == "Y"
        @client_tracking = response_body["ClientTracking"] || nil
        @total_tax = Amount.new(response_body["TotalTax"])

        build_groups(response_body)
        build_item_messages(response_body)
      end

      def success?
        @success
      end

      def item_errors?
        @status == "9001"
      end

      private

      def build_groups(response_body)
        @groups = []
        if response_body["GroupList"].respond_to?(:map)
          @groups = response_body.fetch("GroupList").map do |group|
            Group.new(group)
          end
        end
      end

      def build_item_messages(response_body)
        @item_messages = Array(response_body.fetch("ItemMessages", [])).map do |item_message|
          ItemMessage.new(item_message)
        end
      end
    end
  end
end
