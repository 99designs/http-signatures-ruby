# frozen_string_literal: true

require 'net/http'
require 'time'

RSpec.describe HttpSignatures::Verifier do
  DATE = 'Fri, 01 Aug 2014 13:44:32 -0700'
  DATE_DIFFERENT = 'Fri, 01 Aug 2014 13:44:33 -0700'

  subject(:verifier) { HttpSignatures::Verifier.new(key_store: key_store) }
  let(:key_store) { HttpSignatures::KeyStore.new('pda' => 'secret') }
  let(:message) { Net::HTTP::Get.new('/path?query=123', headers) }
  let(:headers) { { 'Date' => DATE, 'Signature' => signature_header } }

  let(:signature_header) do
    'keyId="pda",' \
    'algorithm="hmac-sha256",' \
    'headers="(request-target) date",' \
    'signature="cS2VvndvReuTLy52Ggi4j6UaDqGm9hMb4z0xJZ6adqU="'
  end

  it 'verifies a valid message' do
    expect(verifier.valid?(message)).to eq(true)
  end

  it 'rejects message with missing headers' do
    headers.clear
    expect(verifier.valid?(message)).to eq(false)
  end

  it 'rejects message with tampered path' do
    message.path << 'x'
    expect(verifier.valid?(message)).to eq(false)
  end

  it 'rejects message with tampered date' do
    message['Date'] = DATE_DIFFERENT
    expect(verifier.valid?(message)).to eq(false)
  end

  it 'rejects message with tampered signature' do
    message['Signature'] = message['Signature'].sub('signature="', 'signature="x')
    expect(verifier.valid?(message)).to eq(false)
  end

  it 'rejects message with malformed signature' do
    message['Signature'] = 'foo=bar,baz=bla,yadda=yadda'
    expect(verifier.valid?(message)).to eq(false)
  end
end
