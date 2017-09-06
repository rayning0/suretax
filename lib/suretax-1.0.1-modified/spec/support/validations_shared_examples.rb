require "spec_helper"

shared_examples_for "optional phone number" do
  it "can be blank" do
    request_item.send("#{subject}=", nil)

    expect(request_item.errors.any?).to eq false
  end

  it "must be numeric" do
    request_item.send("#{subject}=", "abcdefghij")

    expect(request_item.errors.any?).to eq true
    expect(request_item.errors.messages).to eq [%(Invalid #{subject}: abcdefghij)]
  end

  it "must ten digits" do
    request_item.send("#{subject}=", "1" * 11)

    expect(request_item.errors.any?).to eq true
    expect(request_item.errors.messages).to eq [%(Invalid #{subject}: #{'1' * 11})]

    request_item.send("#{subject}=", "1" * 9)

    expect(request_item.errors.any?).to eq true
    expect(request_item.errors.messages).to eq [%(Invalid #{subject}: #{'1' * 9})]
  end
end
