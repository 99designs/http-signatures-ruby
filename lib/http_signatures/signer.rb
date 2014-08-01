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
        signature: signature(message).to_str,
      )
    end

    def signature(message)
      Signature.new(
        message: message,
        key: @key,
        algorithm: @algorithm,
        header_list: @header_list,
      )
    end

  end
end
