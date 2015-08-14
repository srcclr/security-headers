module Headlines
  module SecurityHeaders
    class ContentSecurityPolicy < SecurityHeader
      def parse
        results = {}
        value.split(";").each do |parameter|
          key = parameter.split(" ")[0].gsub("-", "_")
          value = parameter.split(" ")[1..-1].join(" ")
          results[key.to_sym] = value
        end

        results[:enabled] = results.any?
        results
      end
    end
  end
end
