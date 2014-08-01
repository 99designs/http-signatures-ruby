module HttpSignatures
  class Signature

    def initialize(message:, key:, algorithm:, header_list:)
      @message = message
      @key = key
      @algorithm = algorithm
      @header_list = header_list
    end

    def to_str
      @algorithm.sign(@key.secret, signing_string)
    end

    private

    def signing_string
      SigningString.new(
        header_list: @header_list,
        message: @message,
      ).to_str
    end

  end
end
