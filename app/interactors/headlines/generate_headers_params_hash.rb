module Headlines
  class GenerateHeadersParamsHash
    include Interactor

    def call
      context.params = headers_hash
    end

    private

    def headers_hash
      Hash[context.headers.map { |header| [header.name, header.params] }]
    end
  end
end
