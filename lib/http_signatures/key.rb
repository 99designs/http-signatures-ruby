module HttpSignatures
  class Key

    def initialize(id:, secret:)
      @id = id
      @secret = secret
    end

    attr_reader :id
    attr_reader :secret

    def ==(other)
      self.class == other.class &&
        self.id == other.id &&
        self.secret == other.secret
    end

  end
end
