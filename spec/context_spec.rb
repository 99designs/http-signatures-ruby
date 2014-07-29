require "http_signatures/algorithm/null"
require "http_signatures/context"
require "http_signatures/signer"
require "net/http"

RSpec.describe HttpSignatures::Context do

  subject(:context) do
    HttpSignatures::Context.new(
      keys: {"hello" => "world"},
      algorithm: "null",
      headers: %w{(request-target) date content-length},
    )
  end

  let(:message) { Net::HTTP::Get.new("/", "date" => "x", "content-length" => "0") }

  describe "#signer" do
    it "instantiates Signer with key, algorithm, headers" do
      expect(HttpSignatures::Signer).to receive(:new) do |args|
        expect(args[:key]).to eq(HttpSignatures::Key.new(id: "hello", secret: "world"))
        expect(args[:algorithm].name).to eq("null")
        expect(args[:header_list].to_a).to eq(%w{(request-target) date content-length})
      end
      context.signer("hello")
    end

    it "signs without errors" do
      context.signer("hello").sign(message)
    end
  end

end
