module Suretax
  TAX_SITUS_RULES = {
    two_of_three:       "01",
    billed_to_number:   "02",
    origination_number: "03",
    billing_zip:        "04",
    billing_zip_plus_4: "05",
    private_lines:      "06",
    point_to_point:     "07",
    vat:                "14"
  }.freeze
end
