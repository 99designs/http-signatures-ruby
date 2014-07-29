module HttpSignatures
  module Algorithm
    class Null

      def name
        "null"
      end

      def sign(key, data)
        "null"
      end

    end
  end
end
