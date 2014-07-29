require "http_signatures/key"

module HttpSignatures
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
      @keys[id] = Key.new(id: id, secret: secret)
    end

  end
end
