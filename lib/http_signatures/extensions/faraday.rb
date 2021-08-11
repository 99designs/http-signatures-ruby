require 'faraday'

module HttpSignatures
  module Extensions
    class Faraday < ::Faraday::Middleware
      SIGNATURE_HEADER = 'Signature'.freeze

      def on_request(env)
        env[:request_headers][SIGNATURE_HEADER] = sign_request(env)
      end

      private

      def sign_request(env)
        signer = build_signer(env)
        net_http_request = create_request(env)
        signer.sign(net_http_request)

        net_http_request[SIGNATURE_HEADER]
      end

      def build_signer(env)
        headers = env.request_headers.keys
        headers.unshift(SigningString::REQUEST_TARGET)
        context = HttpSignatures::Context.new(headers: headers, **options)
        context.signer
      end

      def create_request(env)
        request =
          Net::HTTPGenericRequest.new(
            env[:method].to_s.upcase, # request method
            !!env[:body], # is there request body
            env[:method] != :head, # is there response body
            env[:url].request_uri, # request uri path
            env.request_headers # request headers
          )

        request.body = env[:body]

        request
      end
    end
  end
end

Faraday::Request.register_middleware(
  signature: HttpSignatures::Extensions::Faraday
)
