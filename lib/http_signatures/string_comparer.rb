require "digest"

module HttpSignatures
  class StringComparer

    # Based on ActiveSupport secure_compare and variable_size_secure_compare
    # https://github.com/rails/rails/blob/17e6f150/activesupport/lib/active_support/security_utils.rb
    def equal?(a, b)
      a = ::Digest::SHA256.hexdigest(a)
      b = ::Digest::SHA256.hexdigest(b)
      l = a.unpack("C#{a.bytesize}")
      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end

  end
end
