# frozen_string_literal: true

RSpec.describe HttpSignatures::SignatureParameters do
  subject(:signature_parameters) do
    HttpSignatures::SignatureParameters.new(
      key: key,
      algorithm: algorithm,
      header_list: header_list,
      signature: signature
    )
  end

  let(:key) { instance_double('HttpSignatures::Key', id: 'pda') }
  let(:algorithm) { instance_double('HttpSignatures::Algorithm::Hmac', name: 'hmac-test') }
  let(:header_list) { instance_double('HttpSignatures::HeaderList', to_str: 'a b c') }
  let(:signature) { instance_double('HttpSignatures::Signature', to_str: 'sigstring') }

  describe '#to_str' do
    it 'builds parameters into string' do
      expect(signature_parameters.to_str).to eq(
        'keyId="pda",algorithm="hmac-test",headers="a b c",signature="c2lnc3RyaW5n"'
      )
    end
  end
end
