require "http_signatures/algorithm/null"
require "http_signatures/key"
require "http_signatures/signer"

RSpec.describe HttpSignatures::Signer do

  subject(:signer) do
    HttpSignatures::Signer.new(key: key, algorithm: algorithm)
  end
  let(:key) { HttpSignatures::Key.new(id: "pda", secret: "sh") }
  let(:algorithm) { HttpSignatures::Algorithm::Null.new(key: nil) }

  let(:message) do
    HttpSignatures::Message.new(
      header: {"Date" => ["Mon, 28 Jul 2014 15:39:13 -0700"]},
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
    before { signer.sign(message) }
    it "does not add signature to passed message" do
      expect(message.header.key?("Signature")).to eq(false)
    end
  end

  describe "#signed_message" do
    let(:signed_message) { signer.sign(message) }
    it "has valid signature structure" do
      expect(signed_message.header["Signature"][0]).to match(signature_structure_pattern)
    end
    it "matches expected signature header" do
      expect(signed_message.header["Signature"][0]).to eq(
        'keyId="pda",algorithm="null",signature="TODO/signature"'
      )
    end
  end

end
