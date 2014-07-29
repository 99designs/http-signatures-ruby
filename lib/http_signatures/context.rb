require "http_signatures/key"
require "http_signatures/signer"

module HttpSignatures
  class Context

    def initialize(keys: {}, algorithm: nil, headers: nil)
      @key_store = KeyStore.new(keys)
      @algorithm = algorithm
      @headers = headers
    end

    def signer(key_id)
      HttpSignatures::Signer.new(
        key: @key_store.fetch(key_id),
        algorithm: @algorithm,
        headers: @headers,
      )
    end

    class KeyStore

      def initialize(key_hash)
        @keys = {}
        key_hash.each { |id, secret| self[id] = secret }
      end

      def []=(id, secret)
        @keys[id] = HttpSignatures::Key.new(id: id, secret: secret)
      end

      def fetch(id)
        @keys.fetch(id)
      end

    end

  end
end
