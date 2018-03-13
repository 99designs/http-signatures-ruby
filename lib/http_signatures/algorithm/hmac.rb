# frozen_string_literal: true

require 'openssl'

module HttpSignatures
  module Algorithm
    class Hmac
      def initialize(digest_name)
        @digest_name = digest_name
        @digest = OpenSSL::Digest.new(digest_name)
      end

      def name
        "hmac-#{@digest_name}"
      end

      def sign(key, data)
        OpenSSL::HMAC.digest(@digest, key, data)
      end
    end
  end
end
