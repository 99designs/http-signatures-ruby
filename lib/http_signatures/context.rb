require "http_signatures/algorithm"
require "http_signatures/key_store"
require "http_signatures/signer"

module HttpSignatures
  class Context

    def initialize(keys: {}, algorithm: nil, headers: nil)
      @key_store = HttpSignatures::KeyStore.new(keys)
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

  end
end
