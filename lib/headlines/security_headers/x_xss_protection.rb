module Headlines
  module SecurityHeaders
    class XXssProtection < SecurityHeader
      def parse
        {}.tap do |results|
          results[:enabled] = @value.start_with?("1")
          if results[:enabled]
            results[:mode] = "block" if @value.gsub(" ", "").scan(";mode=block").any?
            results[:report_url] = Regexp.last_match[1] if @value =~ /report=(.+)/
          end
        end
      end
    end
  end
end
