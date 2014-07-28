module HttpSignatures
  class MessageHeader

    def initialize(fields = {})
      @fields = Hash.new { |hash, key| hash[key] = [] }
      fields.each do |k, v|
        self[k] = v
      end
    end

    def key?(name)
      @fields.key?(normalize(name))
    end

    def [](name)
      @fields[normalize(name)]
    end

    def []=(name, values)
      # values is expected to be an array
      @fields[normalize(name)] = values
    end

    def each
      @fields.each { |name, v| yield(normalize(name), v) }
    end

    private

    def normalize(name)
      name.downcase
    end

  end
end
