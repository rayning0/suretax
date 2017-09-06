require "spec_helper"

describe Suretax::Api::Amount do
  let(:tax_amount) { Suretax::Api::Amount.new("1.394490") }

  let(:params) {
    {
      amount: 1_394_490,
      precision: 6,
      divisor: 1_000_000
    }
  }

  it "should return a Float for #to_f" do
    expect(tax_amount.to_f).to eql(1.394490)
  end

  it "should return a String for #to_s" do
    expect(tax_amount.to_s).to eql("1.394490")
  end

  it "should provide an integer version via #to_i" do
    expect(tax_amount.to_i).to eql(1_394_490)
  end

  it "should provide a hard currency value via #cents" do
    expect(tax_amount.cents).to eql(139)
  end

  it "should give the number of decimal places via #precision" do
    expect(tax_amount.precision).to eql(6)
  end

  it "should give integer parameters for calculating the Float via #params" do
    expect(tax_amount.params).to eql(params)
  end
end
