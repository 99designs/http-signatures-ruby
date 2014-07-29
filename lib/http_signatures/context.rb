module HttpSignatures
  class Context

    def initialize(keys: {}, algorithm: nil, headers: nil)
      @key_store = KeyStore.new(keys)
      @algorithm_name = algorithm
      @headers = headers
    end

    def signer(key_id)
      Signer.new(
        key: @key_store.fetch(key_id),
        algorithm: Algorithm.create(@algorithm_name),
        header_list: HeaderList.new(@headers),
      )
    end

  end
end
