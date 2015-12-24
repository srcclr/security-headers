module Typhoeus
  class EasyFactory
    private

    alias_method :original_sanitize, :sanitize

    def sanitize(options)
      sanitized = original_sanitize(options)
      sanitized[:headers] = sanitized[:headers].slice!("User-Agent")
      sanitized
    end
  end
end
