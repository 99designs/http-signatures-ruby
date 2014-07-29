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

    private

    def validate_names!
      if illegal_headers_present.any?
        raise IllegalHeader, illegal_headers_present
      end
    end

    def illegal_headers_present
      ILLEGAL & to_a
    end

    class IllegalHeader < StandardError
      def initialize(names)
        names_string = names.map { |n| "'#{n}'" }.join(", ")
        super("Header #{names_string} not permitted")
      end
    end

  end
end
