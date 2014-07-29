require "http_signatures/message"
require "http_signatures/signature_parameters"

module HttpSignatures
  class Signer

    def initialize(key:, algorithm:, header_names:)
      raise(EmptyHeaderNames) if header_names.empty?
      @key = key
      @algorithm = algorithm
      @header_names = header_names
    end

    def sign(message)
      message.dup.tap do |m|
        m.header["Signature"] = [signature_parameters_for_message(message).to_str]
      end
    end

    private

    def signature_parameters_for_message(message)
      SignatureParameters.new(
        key_id: @key.id,
        algorithm_name: @algorithm.name,
        header_names: @header_names,
        signature: signature_for_message(message),
      )
    end

    def signature_for_message(message)
      @algorithm.sign(signing_string_for_message(message))
    end

    def signing_string_for_message(message)
      @header_names.map do |name|
        "%s: %s" % [name, message.header[name].join("")]
      end.join("\n")
    end

    class EmptyHeaderNames < StandardError; end

  end
end
