require "timeout"

RSpec.describe HttpSignatures::StringComparer do

  subject(:comparer) { HttpSignatures::StringComparer.new }

  it "is true for same string" do
    expect(comparer.equal?("foo", "foo")).to eq(true)
  end

  it "is false for different string" do
    expect(comparer.equal?("foo", "bar")).to eq(false)
  end

  it "is false for different length string" do
    expect(comparer.equal?("foo", "foobar")).to eq(false)
  end

end
