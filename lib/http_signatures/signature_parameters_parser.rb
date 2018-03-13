# frozen_string_literal: true

module HttpSignatures
  class SignatureParametersParser
    def initialize(string)
      @string = string
    end

    def parse
      Hash[array_of_pairs]
    end

    private

    def array_of_pairs
      segments.map { |segment| pair(segment) }
    end

    def segments
      @string.split(',')
    end

    def pair(segment)
      match = segment_pattern.match(segment)
      raise Error, "unparseable segment: #{segment}" if match.nil?
      match.captures
    end

    def segment_pattern
      /\A(keyId|algorithm|headers|signature)="(.*)"\z/
    end

    class Error < StandardError; end
  end
end
