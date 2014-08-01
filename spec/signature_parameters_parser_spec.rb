RSpec.describe HttpSignatures::SignatureParametersParser do

  subject(:parser) do
    HttpSignatures::SignatureParametersParser.new(input)
  end

  let(:input) do
    'keyId="example",algorithm="hmac-sha1",headers="(request-target) date",signature="b64"'
  end

  describe "#parse" do
    it "returns hash with string keys matching those in the parsed string" do
      expect(parser.parse).to eq(
        {
          "keyId" => "example",
          "algorithm" => "hmac-sha1",
          "headers" => "(request-target) date",
          "signature" => "b64",
        }
      )
    end
  end

end
