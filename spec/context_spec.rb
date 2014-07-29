require "net/http"

RSpec.describe HttpSignatures::Context do

  let(:message) { Net::HTTP::Get.new("/", "date" => "x", "content-length" => "0") }

  context "with one key in KeyStore, no signing_key_id specified" do
    subject(:context) do
      HttpSignatures::Context.new(
        keys: {"hello" => "world"},
        algorithm: "null",
        headers: %w{(request-target) date content-length},
      )
    end

    describe "#signer" do
      it "instantiates Signer with key, algorithm, headers" do
        expect(HttpSignatures::Signer).to receive(:new) do |args|
          expect(args[:key]).to eq(HttpSignatures::Key.new(id: "hello", secret: "world"))
          expect(args[:algorithm].name).to eq("null")
          expect(args[:header_list].to_a).to eq(%w{(request-target) date content-length})
        end
        context.signer
      end

      it "signs without errors" do
        context.signer.sign(message)
      end
    end
  end

  context "with two keys in KeyStore, signing_key_id specified" do
    subject(:context) do
      HttpSignatures::Context.new(
        keys: {"hello" => "world", "another" => "key"},
        signing_key_id: "another",
        algorithm: "null",
        headers: %w{(request-target) date content-length},
      )
    end

    describe "#signer" do
      it "instantiates Signer with key, algorithm, headers" do
        expect(HttpSignatures::Signer).to receive(:new) do |args|
          expect(args[:key]).to eq(HttpSignatures::Key.new(id: "another", secret: "key"))
          expect(args[:algorithm].name).to eq("null")
          expect(args[:header_list].to_a).to eq(%w{(request-target) date content-length})
        end
        context.signer
      end

      it "signs without errors" do
        context.signer.sign(message)
      end
    end
  end

end
