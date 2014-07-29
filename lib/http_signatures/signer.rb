require "http_signatures/message"
require "http_signatures/signature_parameters"

module HttpSignatures
  class Signer

    DEFAULT_HEADERS = ["date"]

    def initialize(key:, algorithm:, headers: nil)
      @key = key
      @algorithm = algorithm
      @headers = headers
    end

    def sign(message)
      message.dup.tap do |m|
        m.header["Signature"] = [signature_parameters_for_message(message).to_s]
      end
    end

    private

    def signature_parameters_for_message(message)
      signature = signature_for_message(message)
      SignatureParameters.new(
        key_id: @key.id,
        algorithm_name: @algorithm.name,
        header_names: @header_names,
        signature: signature,
      )
    end

    def signature_for_message(message)
      @algorithm.sign(signing_string_for_message(message))
    end

    def signing_string_for_message(message)
      specified_or_default_header_names.map do |name|
        "%s: %s" % [name, message.header[name].join("")]
      end.join("\n")
    end

    def specified_or_default_header_names
      @headers || DEFAULT_HEADERS
    end

  end
end
