module HttpSignatures
  class SignatureParameters

    def initialize(key_id:, algorithm_name:, header_names:, signature:)
      @key_id = key_id
      @algorithm_name = algorithm_name
      @header_names = header_names
      @signature = signature
    end

    # TODO: to_str instead/also?
    def to_s
      'keyId="%s",algorithm="%s",signature="%s"' % [
        @key_id,
        @algorithm_name,
        @signature,
      ]
    end

    private

  end
end
