require "base64"
require "http_signatures/algorithm"

RSpec.describe HttpSignatures::Algorithm do

  let(:key) { "the-key" }
  let(:input) { "the string\nto sign" }

  {
    "null" => "bnVsbA==", # "null"
    "hmac-sha1" => "bXPeVc5ySIyeUapN7mpMsJRnxVg=",
    "hmac-sha256" => "hRQ5zpbGudR1hokS4PqeAkveKmz2dd8SCgV8OHcramI=",
  }.each do |name, base64_signature|

    describe name do
      it "produces known-good signature" do
        algorithm = HttpSignatures::Algorithm.create(name: name, key: key)
        signature = algorithm.sign(input)
        expect(signature).to eq(Base64.strict_decode64(base64_signature))
      end
    end

  end

  it "raises error for unknown algorithm" do
    expect {
      HttpSignatures::Algorithm.create(name: "nope", key: nil)
    }.to raise_error(HttpSignatures::Algorithm::UnknownAlgorithm)
  end

end
