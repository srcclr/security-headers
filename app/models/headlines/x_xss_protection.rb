module Headlines
  class XXssProtection < SecurityHeader
    def parse
      @params[:enabled] = @header.start_with?('1')
      @params[:mode] = Regexp.last_match[1] if @header =~ /mode=(\w+)/
      self
    end
  end
end
