module Headlines
  module SecurityHeaders
    class StrictTransportSecurity < SecurityHeader
      def parse
        {}.tap do |results|
          results[:max_age] = Regexp.last_match[1] if value =~ /max-age=(\d+)/
          results[:includeSubDomains] = value.gsub(" ", "").scan(";includeSubDomains").any?
          results[:enabled] = results[:max_age] && results[:max_age].to_i > 0
        end
      end
    end
  end
end
