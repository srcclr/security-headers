module Headlines
  module Ratings
    class CspHeaderCalculator < BaseCalculator
      private

      def ok?
        score == 3
      end

      def warn?
        score == 2
      end
    end
  end
end
