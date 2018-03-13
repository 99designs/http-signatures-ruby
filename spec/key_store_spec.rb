# frozen_string_literal: true

RSpec.describe HttpSignatures::KeyStore do
  subject(:store) do
    HttpSignatures::KeyStore.new(
      'hello' => 'world',
      'another' => 'key'
    )
  end

  describe '#fetch' do
    it 'retrieves keys' do
      expect(store.fetch('hello')).to eq(
        HttpSignatures::Key.new(id: 'hello', secret: 'world')
      )
    end

    it 'raises KeyError' do
      expect do
        store.fetch('nope')
      end.to raise_error(KeyError)
    end
  end
end
