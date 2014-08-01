module HttpSignatures
  class Signer

    AUTHORIZATION_SCHEME = "Signature"

    def initialize(key:, algorithm:, header_list:)
      @key = key
      @algorithm = algorithm
      @header_list = header_list
    end

    def sign(message)
      message.tap do |m|
        m["Signature"] = [signature_parameters(message).to_str]
        m["Authorization"] = [AUTHORIZATION_SCHEME + " " + signature_parameters(message).to_str]
      end
    end

    private

    def signature_parameters(message)
      SignatureParameters.new(
        key: @key,
        algorithm: @algorithm,
        header_list: @header_list,
        signature: signature_for_message(message),
      )
    end

    def signature_for_message(message)
      @algorithm.sign(@key.secret, signing_string_for_message(message))
    end

    def signing_string_for_message(message)
      SigningString.new(
        header_list: @header_list,
        message: message,
      ).to_str
    end

  end
end
