# frozen_string_literal: true

module HttpSignatures
  class HeaderList
    # Cannot sign the signature headers
    ILLEGAL = %w[authorization signature].freeze

    def self.from_string(string)
      new(string.split(' '))
    end

    def initialize(names)
      @names = names.map(&:downcase)
      validate_names!
    end

    def to_a
      @names.dup
    end

    def to_str
      @names.join(' ')
    end

    private

    def validate_names!
      raise EmptyHeaderList if @names.empty?
      raise IllegalHeader, illegal_headers_present if illegal_headers_present.any?
    end

    def illegal_headers_present
      ILLEGAL & @names
    end

    class IllegalHeader < StandardError
      def initialize(names)
        names_string = names.map { |n| "'#{n}'" }.join(', ')
        super("Header #{names_string} not permitted")
      end
    end

    class EmptyHeaderList < StandardError; end
  end
end
