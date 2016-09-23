require "base64"

module HttpSignatures
  class VerificationAlgorithm
    class Rsa
      def initialize(algorithm)
        @algorithm = algorithm
      end

      def valid?(message:, key:, header_list:, provided_signature_base64:)
        @algorithm.verify(
          key.secret,
          Base64.strict_decode64(provided_signature_base64),
          SigningString.new(
            header_list: header_list,
            message: message,
          ).to_str
        )
      end
    end
  end
end
