module HttpSignatures
  class VerificationAlgorithm
    def self.create(algorithm)
      case algorithm
      when HttpSignatures::Algorithm::Hmac then Hmac.new(algorithm)
      when HttpSignatures::Algorithm::Rsa then Rsa.new(algorithm)
      else raise UnknownAlgorithm.new(algorithm)
      end
    end

    class UnknownAlgorithm < StandardError
      def initialize(algorithm)
        super("Unknown algorithm '#{algorithm}'")
      end
    end
  end
end
