module HttpSignatures
  module Algorithm

    def self.create(name)
      case name
      when "hmac-sha1" then Hmac.new("sha1")
      when "hmac-sha256" then Hmac.new("sha256")
      when "rsa-sha1" then Rsa.new("sha1")
      when "rsa-sha256" then Rsa.new("sha256")
      when "rsa-sha384" then Rsa.new("sha384")
      when "rsa-sha512" then Rsa.new("sha512")
      else raise UnknownAlgorithm.new(name)
      end
    end

    class UnknownAlgorithm < StandardError
      def initialize(name)
        super("Unknown algorithm name '#{name}'")
      end
    end

  end
end
