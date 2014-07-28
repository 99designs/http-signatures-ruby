require "http_signatures/message"
require "http_signatures/signature_parameters"

module HttpSignatures
  class Signer

    def initialize(key:, algorithm:, headers: nil)
      @key = key
      @algorithm = algorithm
    end

    def sign(message)
      message.dup.tap do |m|
        m.header["Signature"] = [signature_parameters_for_message(message).to_s]
      end
    end

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
      "TODO/signature"
    end

  end
end
