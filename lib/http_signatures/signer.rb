require "http_signatures/signature_parameters"

module HttpSignatures
  class Signer

    AUTHORIZATION_SCHEME = "Signature"

    def initialize(key:, algorithm:, header_names:)
      raise(EmptyHeaderNames) if header_names.empty?
      @key = key
      @algorithm = algorithm
      @header_names = header_names
    end

    def sign(message)
      message.tap do |m|
        signature = signature_parameters_for_message(message).to_str
        m["Signature"] = [signature]
        m["Authorization"] = [AUTHORIZATION_SCHEME + " " + signature]
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
      @algorithm.sign(@key.secret, signing_string_for_message(message))
    end

    def signing_string_for_message(message)
      @header_names.map do |name|
        values = message.get_fields(name)
        raise(MessageMissingHeader.new(name)) unless values
        "%s: %s" % [name, values.join("")]
      end.join("\n")
    end

    class EmptyHeaderNames < StandardError; end

    class MessageMissingHeader < StandardError
      def initialize(name)
        super("Message missing header '#{name}'")
      end
    end

  end
end
