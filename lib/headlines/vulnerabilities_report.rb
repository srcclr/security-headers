module Headlines
  class VulnerabilitiesReport
    def initialize(scan_results)
      @scan_results = scan_results
    end

    def report
      Hash[
        Headlines::SECURITY_HEADERS.map { |v| [v.gsub("-", "_"), send("domains_percent_by", v)] }
      ]
    end

    private

    def domains_count_by(vulnerability)
      @scan_results.count { |s| s[vulnerability].to_i < 33 }
    end

    def domains_percent_by(vulnerability)
      ((domains_count_by(vulnerability).to_f / @scan_results.size) * 100).round
    end
  end
end
