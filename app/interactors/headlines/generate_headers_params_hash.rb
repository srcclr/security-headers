module Headlines
  class GenerateHeadersParamsHash
    include Interactor

    def call
      context.params = headers_hash(context.headers)
    end

    private

    def headers_hash(headers)
      Hash[headers.map { |header| [header.name, header.params] }]
    end
  end
end
