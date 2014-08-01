RSpec.describe HttpSignatures::SignatureParameters do

  subject(:signature_parameters) do
    HttpSignatures::SignatureParameters.new(
      key: key,
      algorithm: algorithm,
      header_list: header_list,
      signature: signature,
    )
  end

  let(:key) { double("Key", id: "pda") }
  let(:algorithm) { double("Algorithm", name: "hmac-test") }
  let(:header_list) { double("HeaderList", to_str: "a b c") }
  let(:signature) { "sigstring" }

  describe "#to_str" do
    it "builds parameters into string" do
      expect(signature_parameters.to_str).to eq(
        'keyId="pda",algorithm="hmac-test",headers="a b c",signature="c2lnc3RyaW5n"'
      )
    end
  end

end
