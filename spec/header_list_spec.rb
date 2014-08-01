RSpec.describe HttpSignatures::HeaderList do

  describe ".from_string" do
    it "loads and normalizes header names" do
      expect(HttpSignatures::HeaderList).to receive(:new).with(
        ["(request-target)", "Date", "Content-Type"]
      )
      HttpSignatures::HeaderList.from_string(
        "(request-target) Date Content-Type"
      )
    end
  end

  describe ".new" do
    it "normalizes header names (downcase)" do
      list = HttpSignatures::HeaderList.new(["(request-target)", "Date", "Content-Type"])
      expect(list.to_a).to eq(["(request-target)", "date", "content-type"])
    end

    ["Authorization", "Signature"].each do |header|
      it "raises IllegalHeader for #{header} header" do
        expect {
          HttpSignatures::HeaderList.new([header])
        }.to raise_error(HttpSignatures::HeaderList::IllegalHeader)
      end
    end
  end

  describe "#to_str" do
    it "joins normalized header names with spaces" do
      list = HttpSignatures::HeaderList.new(["(request-target)", "Date", "Content-Type"])
      expect(list.to_str).to eq("(request-target) date content-type")
    end
  end

end
