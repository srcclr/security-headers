module Headlines
  class XContentTypeOptions < SecurityHeader
    def parse
      @params[:nosniff] = @header.scan('nosniff').any?
      self
    end

    def score
      @params[:enabled] && @params[:nosniff] ? 1 : 0
    end
  end
end
