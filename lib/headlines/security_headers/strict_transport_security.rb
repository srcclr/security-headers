module Headlines
  module SecurityHeaders
    class StrictTransportSecurity < SecurityHeader
      def parse
        {}.tap do |results|
          results[:enabled] = true
          results[:includeSubDomains] = @value.scan("includeSubDomains").any?
          results[:max_age] = Regexp.last_match[1] if @value =~ /max-age=(\d+)/
        end
      end
    end
  end
end
