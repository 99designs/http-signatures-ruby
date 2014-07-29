require "http_signatures/algorithm/null"
require "http_signatures/context"
require "http_signatures/signer"

RSpec.describe HttpSignatures::Context do

  subject(:context) do
    HttpSignatures::Context.new(
      keys: {"hello" => "world"},
      algorithm: HttpSignatures::Algorithm::Null,
      headers: %w{(request-target) date content-length},
    )
  end

  describe "#signer" do
    it "instantiates Signer with key, algorithm, headers" do
      expect(HttpSignatures::Signer).to receive(:new).with(
        key: HttpSignatures::Key.new(id: "hello", secret: "world"),
        algorithm: HttpSignatures::Algorithm::Null,
        headers: %w{(request-target) date content-length},
      )
      context.signer("hello")
    end
  end

end
