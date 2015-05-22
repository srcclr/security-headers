module Headlines
  class SecurityHeader
    attr_reader :params

    def initialize(header)
      @header = header[1]
      @params = { header: header[0], value: @header, enabled: true }
    end

    def score
      @params[:enabled] ? 1 : 0
    end
  end
end
