require "net/http"

RSpec.describe HttpSignatures::Signer do

  EXAMPLE_DATE = "Mon, 28 Jul 2014 15:39:13 -0700"

  subject(:signer) do
    HttpSignatures::Signer.new(key: key, algorithm: algorithm, header_list: header_list)
  end
  let(:key) { HttpSignatures::Key.new(id: "pda", secret: "sh") }
  let(:algorithm) { HttpSignatures::Algorithm::Hmac.new("sha256") }
  let(:header_list) { HttpSignatures::HeaderList.new(["date", "content-type"]) }

  let(:message) do
    Net::HTTP::Get.new(
      "/path?query=123",
      "Date" => EXAMPLE_DATE,
      "Content-Type" => "text/plain",
      "Content-Length" => "123",
    )
  end

  let(:authorization_structure_pattern) do
    %r{
      \A
      Signature
      \s
      keyId="[\w-]+",
      algorithm="[\w-]+",
      (?:headers=".*",)?
      signature="[a-zA-Z0-9/+=]+"
      \z
    }x
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
    it "passes correct signing string to algorithm" do
      expect(algorithm).to receive(:sign).with(
        "sh",
        ["date: #{EXAMPLE_DATE}", "content-type: text/plain"].join("\n")
      ).at_least(:once).and_return("static")
      signer.sign(message)
    end
    it "returns reference to the mutated input" do
      expect(signer.sign(message)).to eq(message)
    end
  end

  context "after signing" do
    before { signer.sign(message) }
    it "has valid Authorization header structure" do
      expect(message["Authorization"]).to match(authorization_structure_pattern)
    end
    it "has valid Signature header structure" do
      expect(message["Signature"]).to match(signature_structure_pattern)
    end
    it "matches expected Authorization header" do
      expect(message["Authorization"]).to eq(
        'Signature keyId="pda",algorithm="hmac-sha256",' +
          'headers="date content-type",signature="0ZoJq6cxYZRXe+TN85whSuQgJsam1tRyIal7ni+RMXA="'
      )
    end
    it "matches expected Signature header" do
      expect(message["Signature"]).to eq(
        'keyId="pda",algorithm="hmac-sha256",' +
          'headers="date content-type",signature="0ZoJq6cxYZRXe+TN85whSuQgJsam1tRyIal7ni+RMXA="'
      )
    end
  end

end
