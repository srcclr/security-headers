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

      def to_h
        { id: id, title: title, path: path }
      end
    end
  end
end
