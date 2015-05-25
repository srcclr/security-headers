module Headlines
  module SecurityHeaders
    class StrictTransportSecurity < SecurityHeader
      def parse
        @params[:includeSubDomains] = @header.scan("includeSubDomains").any?
        @params[:max_age] = Regexp.last_match[1] if @header =~ /max-age=(\d+)/
        self
      end
    end
  end
end
