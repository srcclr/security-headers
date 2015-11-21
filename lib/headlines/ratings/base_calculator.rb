module Headlines
  module Ratings
    class BaseCalculator
      attr_reader :score
      private :score

      def initialize(score)
        @score = score
      end

      def call
        return "OK" if ok?

        warn? ? "WARN" : "ERROR"
      end
    end
  end
end
