module Headlines
  module SecurityHeaders
    class XXssProtection < SecurityHeader
      def parse
        {}.tap do |results|
          results[:enabled] = @value.start_with?("1")
          results[:mode] = Regexp.last_match[1] if @value =~ /mode=(\w+)/
        end
      end
    end
  end
end
