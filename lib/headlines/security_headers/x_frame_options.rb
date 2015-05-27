module Headlines
  module SecurityHeaders
    class XFrameOptions < SecurityHeader
      def parse
        {}.tap do |results|
          results[:deny] = true if @value.eql?("DENY")
          results[:sameorigin] = true if @value.eql?("SAMEORIGIN")
          results[:allow_from] = Regexp.last_match[1] if @value =~ %r{^ALLOW-FROM (https?://.+)$}
          results[:enabled] = results.any?
        end
      end
    end
  end
end
