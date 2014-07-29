require "base64"

module HttpSignatures
  class SignatureParameters

    def initialize(key_id:, algorithm_name:, header_names:, signature:)
      @key_id = key_id
      @algorithm_name = algorithm_name
      @header_names = header_names
      @signature = signature
    end

    def to_str
      parameter_components.join(",")
    end

    private

    def parameter_components
      pc = []
      pc << 'keyId="%s"' % @key_id
      pc << 'algorithm="%s"' % @algorithm_name
      pc << 'headers="%s"' % header_name_list
      pc << 'signature="%s"' % signature_base64
      pc
    end

    def header_name_list
      @header_names.join(" ")
    end

    def signature_base64
      Base64.strict_encode64(@signature)
    end

  end
end
