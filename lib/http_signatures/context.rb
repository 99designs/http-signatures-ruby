require "http_signatures/key"
require "http_signatures/signer"

module HttpSignatures
  class Context

    def initialize(keys: {}, algorithm: nil, headers: nil)
      @key_store = KeyStore.new(keys)
      @algorithm_name = algorithm
      @headers = headers
    end

    def signer(key_id)
      HttpSignatures::Signer.new(
        key: @key_store.fetch(key_id),
        algorithm: HttpSignatures::Algorithm.create(@algorithm_name),
        headers: @headers,
      )
    end

    class KeyStore

      def initialize(key_hash)
        @keys = {}
        key_hash.each { |id, secret| self[id] = secret }
      end

      def fetch(id)
        @keys.fetch(id)
      end

      private

      def []=(id, secret)
        @keys[id] = HttpSignatures::Key.new(id: id, secret: secret)
      end

    end

  end
end
