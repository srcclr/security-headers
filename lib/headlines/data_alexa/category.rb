module Headlines
  class DataAlexa
    class Category
      attr_reader :node

      def initialize(node)
        @node = node
      end

      def id
        @node["CID"]
      end

      def title
        @node["TITLE"]
      end

      def path
        @node["ID"]
      end
    end
  end
end
