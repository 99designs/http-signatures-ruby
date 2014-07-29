require "openssl"

module HttpSignatures
  module Algorithm
    class Hmac

      def initialize(digest_name, key)
        @digest = OpenSSL::Digest.new(digest_name)
        @key = key
      end

      def sign(data)
        OpenSSL::HMAC.digest(@digest, @key, data)
      end

    end
  end
end
