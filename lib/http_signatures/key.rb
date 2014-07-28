module HttpSignatures
  class Key

    def initialize(id:, secret:)
      @id = id
      @secret = secret
    end

    attr_reader :id
    attr_reader :secret

  end
end
