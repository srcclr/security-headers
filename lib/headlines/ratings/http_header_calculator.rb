module Headlines
  module Ratings
    class HttpHeaderCalculator < BaseCalculator
      private

      def ok?
        score > 0
      end

      def warn?
        score == 0
      end
    end
  end
end
