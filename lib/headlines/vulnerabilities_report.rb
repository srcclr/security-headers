module Headlines
  class VulnerabilitiesReport
    def initialize(scan_results)
      @scan_results = scan_results
    end

    def report
      Hash[SECURITY_HEADERS.map { |h| [h, bad_domains_percent_by(h)] }]
    end

    private

    def bad_domains_count_by(header)
      @scan_results.count { |s| s[header].to_i < 20 }
    end

    def bad_domains_percent_by(header)
      ((bad_domains_count_by(header).to_f / @scan_results.size) * 100).round
    end
  end
end
