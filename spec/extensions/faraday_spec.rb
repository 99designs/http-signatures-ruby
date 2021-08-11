require 'http_signatures/extensions/faraday'

RSpec.describe HttpSignatures::Extensions::Faraday do
  subject(:middleware) { described_class.new(app, options) }

  let(:app) { ->(env) { Faraday::Response.new(env) } }

  def process(url:, body:, headers: {})
    request_headers = Faraday::Utils::Headers.new(headers)
    url = Faraday::Utils.URI(url)
    env = { url: url, body: body, request_headers: request_headers }
    middleware.call(Faraday::Env.from(env)).env
  end

  describe 'success' do
    let(:options) do
      Hash[
        keys: {
          'examplekey' => 'secret-key-here'
        },
        algorithm: 'hmac-sha256'
      ]
    end

    it 'adds the correct signature' do
      result =
        process(
          url: 'https://test.co',
          body: 'hello',
          headers: {
            'content-type' => 'text/plain',
            'date' => Time.at(0).to_date.httpdate
          }
        )

      expect(result[:request_headers]).to include(
        'Signature' =>
          "keyId=\"examplekey\",algorithm=\"hmac-sha256\",headers=\"(request-target) content-type date\",signature=\"T4rbUnrBAKR1WR8ltkIswUp7qMjSCm1HcNZzAF36NdY=\""
      )
    end
  end
end
