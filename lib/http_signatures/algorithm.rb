require "http_signatures/algorithm/null"

module HttpSignatures
  module Algorithm

    def self.create(name:, key:)
      case name
      when "null" then Null.new
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
