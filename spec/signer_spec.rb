require "http_signatures/algorithm/null"
require "http_signatures/key"
require "http_signatures/signer"

RSpec.describe HttpSignatures::Signer do

  EXAMPLE_DATE = "Mon, 28 Jul 2014 15:39:13 -0700"

  subject(:signer) do
    HttpSignatures::Signer.new(key: key, algorithm: algorithm, header_names: headers_to_sign)
  end
  let(:key) { HttpSignatures::Key.new(id: "pda", secret: "sh") }
  let(:algorithm) { HttpSignatures::Algorithm::Null.new }
  let(:headers_to_sign) { ["(request-target)", "date", "content-type"] }

  let(:message) do
    HttpSignatures::Message.new(
      header: {
        "(request-target)" => ["get /path?query=123"],
        "Date" => [EXAMPLE_DATE],
        "Content-Type" => ["text/plain"],
        "Content-Length" => ["123"],
      },
    )
  end

  let(:signature_structure_pattern) do
    %r{
      \A
      keyId="[\w-]+",
      algorithm="[\w-]+",
      (?:headers=".*",)?
      signature="[a-zA-Z0-9/+=]+"
      \z
    }x
  end

  describe "#sign" do
    it "does not add signature to passed message" do
      signer.sign(message)
      expect(message.header.key?("Signature")).to eq(false)
    end
    it "passes correct signing string to algorithm" do
      expect(algorithm).to receive(:sign).with([
        "(request-target): get /path?query=123",
        "date: #{EXAMPLE_DATE}",
        "content-type: text/plain",
      ].join("\n")).and_return("null")
      signer.sign(message)
    end
  end

  describe "#signed_message" do
    let(:signed_message) { signer.sign(message) }
    it "has valid signature structure" do
      expect(signed_message.header["Signature"][0]).to match(signature_structure_pattern)
    end
    it "matches expected signature header" do
      expect(signed_message.header["Signature"][0]).to eq(
        'keyId="pda",algorithm="null",headers="(request-target) date content-type",signature="bnVsbA=="'
      )
    end
  end

end
