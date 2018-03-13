# frozen_string_literal: true

module HttpSignatures
  class Signature
    def initialize(message:, key:, algorithm:, header_list:)
      @message = message
      @key = key
      @algorithm = algorithm
      @header_list = header_list
    end

    def to_str
      @algorithm.sign(@key.secret, signing_string.to_str)
    end

    private

    def signing_string
      SigningString.new(
        header_list: @header_list,
        message: @message
      )
    end
  end
end
