require "base64"

module HttpSignatures
  class SignatureParameters

    def initialize(key:, algorithm:, header_list:, signature:)
      @key = key
      @algorithm = algorithm
      @header_list = header_list
      @signature = signature
    end

    def to_str
      parameter_components.join(",")
    end

    private

    def parameter_components
      pc = []
      pc << 'keyId="%s"' % @key.id
      pc << 'algorithm="%s"' % @algorithm.name
      pc << 'headers="%s"' % @header_list.to_str
      pc << 'signature="%s"' % signature_base64
      pc
    end

    def signature_base64
      Base64.strict_encode64(@signature.to_str)
    end

  end
end
