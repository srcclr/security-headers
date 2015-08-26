module Headlines
  module SecurityHeaders
    class SecurityHeader
      attr_reader :name, :value

      def initialize(name, value)
        @name = name
        @value = value
      end

      def params
        { name: name, value: value, score: score }
      end
    end
  end
end
