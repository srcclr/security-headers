module Headlines
  class ContentSecurityPolicy < SecurityHeader
    def parse
      @header.split(';').each do |parameter|
        key = parameter.split(' ')[0].gsub('-', '_')
        value = parameter.split(' ')[1..-1].join(' ')
        @params[key.to_sym] = value
      end

      self
    end
  end
end
