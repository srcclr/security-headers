module Headlines
  module SecurityHeaders
    class XPermittedCrossDomainPolicies < SecurityHeader
      def score
        value == "master-only" ? 1 : 0
      end
    end
  end
end
