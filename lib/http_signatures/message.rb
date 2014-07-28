require "http_signatures/message_header"

module HttpSignatures
  class Message

    def initialize(header:)
      @header = HttpSignatures::MessageHeader.new(header)
    end

    attr_reader :header

    def dup
      self.class.new(header: @header.dup)
    end

  end
end
