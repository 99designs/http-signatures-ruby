require "net/http"

RSpec.describe HttpSignatures::SigningString do

  DATE = "Tue, 29 Jul 2014 14:17:02 -0700"

  subject(:signing_string) do
    HttpSignatures::SigningString.new(
      header_list: header_list,
      message: message,
    )
  end

  let(:header_list) do
    HttpSignatures::HeaderList.from_string("(request-target) date")
  end

  let(:message) do
    Net::HTTP::Get.new("/path?query=123", "date" => DATE, "x-herring" => "red")
  end

  describe "#to_str" do

    it "returns correct signing string" do
      expect(signing_string.to_str).to eq(
        "(request-target): get /path?query=123\n" +
        "date: #{DATE}"
      )
    end

    context "for header not in message" do
      let(:header_list) { HttpSignatures::HeaderList.from_string("nope") }
      it "raises HeaderNotInMessage" do
        expect {
          signing_string.to_str
        }.to raise_error(HttpSignatures::HeaderNotInMessage)
      end
    end

  end

end
