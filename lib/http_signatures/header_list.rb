module HttpSignatures
  class HeaderList

    # cannot sign the signature headers
    ILLEGAL = ["authorization", "signature"]

    def self.from_string(string)
      new(string.split(" "))
    end

    def initialize(names)
      @names = names.map(&:downcase)
      validate_names!
    end

    def to_a
      @names.dup
    end

    def to_s
      @names.join(" ")
    end

    private

    def validate_names!
      if @names.empty?
        raise EmptyHeaderList
      end
      if illegal_headers_present.any?
        raise IllegalHeader, illegal_headers_present
      end
    end

    def illegal_headers_present
      ILLEGAL & @names
    end

    class IllegalHeader < StandardError
      def initialize(names)
        names_string = names.map { |n| "'#{n}'" }.join(", ")
        super("Header #{names_string} not permitted")
      end
    end

    class EmptyHeaderList < StandardError; end

  end
end
