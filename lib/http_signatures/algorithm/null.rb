module HttpSignatures
  module Algorithm
    class Null

      def name
        "null"
      end

      def sign(string)
        "null"
      end

    end
  end
end
