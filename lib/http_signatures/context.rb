# frozen_string_literal: true

module HttpSignatures
  class Context
    def initialize(keys: {}, signing_key_id: nil, algorithm: nil, headers: nil)
      @key_store = KeyStore.new(keys)
      @signing_key_id = signing_key_id
      @algorithm_name = algorithm
      @headers = headers
    end

    def signer
      Signer.new(
        key: signing_key,
        algorithm: Algorithm.create(@algorithm_name),
        header_list: HeaderList.new(@headers)
      )
    end

    def verifier
      Verifier.new(key_store: @key_store)
    end

    private

    def signing_key
      if @signing_key_id
        @key_store.fetch(@signing_key_id)
      else
        @key_store.only_key
      end
    end
  end
end
