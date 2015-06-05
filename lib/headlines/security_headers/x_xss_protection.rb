module Headlines
  module SecurityHeaders
    class XXssProtection < SecurityHeader
      def parse
        {}.tap do |results|
          if (results[:enabled] = value.start_with?("1"))
            results[:mode] = "block" if value.gsub(" ", "").scan(";mode=block").any?
            results[:report_url] = Regexp.last_match[1] if value =~ /report=(.+)/
          end
        end
      end
    end
  end
end
