require "http_signatures/algorithm/null"
require "http_signatures/algorithm/hmac"

module HttpSignatures
  module Algorithm

    def self.create(name:, key:)
      case name
      when "null" then Null.new
      when "hmac-sha1" then Hmac.new("sha1", key)
      when "hmac-sha256" then Hmac.new("sha256", key)
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
