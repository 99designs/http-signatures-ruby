require "http_signatures/message_header"

RSpec.describe HttpSignatures::MessageHeader do

  subject(:header) { HttpSignatures::MessageHeader.new }

  describe "for missing key" do
    specify "#key? is false" do
      expect(header.key?("nope")).to eq(false)
    end
    specify "#[](name) returns empty array" do
      expect(header["nope"]).to eq([])
    end
  end

  describe "with valid key 'Date'" do
    subject(:header) do
      HttpSignatures::MessageHeader.new("Date" => ["today"])
    end
    specify "#key?('Date') is true" do
      expect(header.key?("Date")).to eq(true)
    end
    specify "#key?('date') is true" do
      expect(header.key?("date")).to eq(true)
    end
    specify "#[]('Date') returns header values" do
      expect(header["Date"]).to eq(["today"])
    end
    specify "#[]('date') returns header values" do
      expect(header["date"]).to eq(["today"])
    end
  end

end
