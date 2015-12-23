module Typhoeus
  class EasyFactory
    private

    def sanitize(options)
      # set nosignal to true by default
      # this improves thread safety and timeout behavior
      sanitized = {:nosignal => true}
      request.options.each do |k,v|
        s = k.to_sym
        next if [:method, :cache_ttl].include?(s)
        if new_option = renamed_options[k.to_sym]
          warn("Deprecated option #{k}. Please use #{new_option} instead.")
          sanitized[new_option] = v
        # sanitize timeouts
        elsif [:timeout_ms, :connecttimeout_ms].include?(s)
          if !v.integer?
            warn("Value '#{v}' for option '#{k}' must be integer.")
          end
          sanitized[k] = v.ceil
        else
          sanitized[k] = v
        end
      end

      sanitize_timeout!(sanitized, :timeout)
      sanitize_timeout!(sanitized, :connecttimeout)

      sanitized[:headers] = sanitized[:headers].slice!("User-Agent")
      sanitized
    end
  end
end
