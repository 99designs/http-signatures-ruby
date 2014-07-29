RSpec.describe HttpSignatures::KeyStore do

  subject(:store) do
    HttpSignatures::KeyStore.new(
      "hello" => "world",
      "another" => "key",
    )
  end

  describe "#fetch" do
    it "retrieves keys" do
      expect(store.fetch("hello")).to eq(
        HttpSignatures::Key.new(id: "hello", secret: "world")
      )
    end
    it "raises KeyError" do
      expect {
        store.fetch("nope")
      }.to raise_error(KeyError)
    end
  end

end
