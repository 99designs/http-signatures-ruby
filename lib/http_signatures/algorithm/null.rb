module HttpSignatures
  module Algorithm
    class Null

      def initialize(key:)
        @key = key
      end

      def name
        "null"
      end

      def sign(string)
        "null"
      end

    end
  end
end
