module HttpSignatures
  class Message

    def initialize(header:)
      @header = Hash.new { [] }
    end

    attr_reader :header

  end
end
