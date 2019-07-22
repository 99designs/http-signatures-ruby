module HttpSignatures
  class Verification

    def initialize(message:, key_store:)
      @message = message
      @key_store = key_store
    end

    def valid?
      signature_header_present? && VerificationAlgorithm.create(algorithm).valid?(
        message: @message,
        key: key,
        header_list: header_list,
        provided_signature_base64: provided_signature_base64
      )
    rescue SignatureParametersParser::Error
      false
    end

    private

    def signature_header_present?
      @message.key?("Signature")
    end

    def provided_signature_base64
      parsed_parameters.fetch("signature")
    end

    def key
      @key_store.fetch(parsed_parameters["keyId"])
    end

    def algorithm
      Algorithm.create(parsed_parameters["algorithm"])
    end

    def header_list
      HeaderList.from_string(parsed_parameters["headers"])
    end

    def parsed_parameters
      @_parsed_parameters ||= SignatureParametersParser.new(fetch_header("Signature")).parse
    end

    def fetch_header(name)
      @message.fetch(name)
    end

  end
end
