module Suretax
  module Api
    class RequestItem
      include Suretax::Concerns::Validatable

      attr_accessor :bill_to_number,
                    :customer_number,
                    :invoice_number,
                    :line_number,
                    :orig_number,
                    :p_to_p_plus_four,
                    :p_to_p_zipcode,
                    :plus_four,
                    :regulatory_code,
                    :revenue,
                    :sales_type_code,
                    :seconds,
                    :tax_included_code,
                    :tax_situs_rule,
                    :term_number,
                    :trans_date,
                    :trans_type_code,
                    :unit_type,
                    :units,
                    :zipcode,
                    :tax_exemption_codes,
                    :user_defined_field,
                    :ship_from_zipcode,
                    :ship_from_plus_four,
                    :order_placement_zipcode,
                    :order_placement_plus_four,
                    :order_approval_zipcode,
                    :order_approval_plus_four,
                    :geocode,
                    :aux_revenue,
                    :aux_revenue_type,
                    :freight_on_board,
                    :ship_from_pob,
                    :mail_order,
                    :common_carrier,
                    :origin_country_code,
                    :dest_country_code

      validate :bill_to_number,
               :customer_number,
               :invoice_number,
               :line_number,
               :orig_number,
               :regulatory_code,
               :sales_type_code,
               :tax_situs_rule,
               :term_number,
               :trans_type_code,
               :tax_exemption_codes

      def initialize(args = {})
        args.each_pair do |key, value|
          send("#{key}=", value.to_s)
        end

        @tax_exemption_codes = []
        args[:tax_exemption_codes].each do |code|
          @tax_exemption_codes << code.to_s
        end

        validate!
      end

      def params
        {
          "LineNumber"           => line_number,
          "InvoiceNumber"        => invoice_number,
          "CustomerNumber"       => customer_number,
          "OrigNumber"           => orig_number      || "",
          "TermNumber"           => term_number      || "",
          "BillToNumber"         => bill_to_number   || "",
          "Zipcode"              => zipcode,
          "Plus4"                => plus_four,
          "P2PZipcode"           => p_to_p_zipcode   || "",
          "P2PPlus4"             => p_to_p_plus_four || "",
          "TransDate"            => trans_date       || Date.today.strftime("%m-%d-%Y"),
          "Revenue"              => revenue.to_f,
          "Units"                => units.to_i,
          "UnitType"             => presence(unit_type) || "00",
          "Seconds"              => seconds.to_i,
          "TaxIncludedCode"      => tax_included_code,
          "TaxSitusRule"         => tax_situs_rule,
          "TransTypeCode"        => trans_type_code,
          "SalesTypeCode"        => sales_type_code,
          "RegulatoryCode"       => regulatory_code,
          "TaxExemptionCodeList" => tax_exemption_codes,
          "UDF"                   => user_defined_field || "",
          "ShipFromZipCode"       => ship_from_zipcode || "",
          "ShipFromPlus4"         => ship_from_plus_four || "",
          "OrderPlacementZipcode" => order_placement_zipcode || "",
          "OrderPlacementPlus4"   => order_approval_plus_four || "",
          "OrderApprovalZipcode"  => order_approval_zipcode || "",
          "OrderApprovalPlus4"    => order_approval_plus_four || "",
          "Geocode"               => geocode || "",
          "AuxRevenue"            => presence(aux_revenue) || "0.00",
          "AuxRevenueType"        => presence(aux_revenue_type) || "01",
          "FreightOnBoard"        => freight_on_board || "",
          "ShipFromPOB"           => presence(ship_from_pob) || "1",
          "MailOrder"             => presence(mail_order) || "1",
          "CommonCarrier"         => presence(common_carrier) || "1",
          "OriginCountryCode"     => origin_country_code || "",
          "DestCountryCode"       => dest_country_code || ""
        }
      end

      def presence(value)
        value unless blank(value)
      end

      def blank(value)
        value.respond_to?(:empty?) ? !!value.empty? : !value
      end
    end
  end
end
