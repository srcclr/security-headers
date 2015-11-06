namespace :headlines do
  desc "Scan existing domains for security vulnerabilities"
  task scan_domains: :environment do
    next if Thread.current[:do_not_perfom_twice]
    Thread.current[:do_not_perfom_twice] = true

    pids = []

    Headlines::Domain.find_in_batches(batch_size: 2500) do |domains|
      pids.push(fork { scan_domains(domains: domains) })
    end

    trap("SIGINT") { pids.each { |pid| Process.kill("SIGINT", pid) } }
    pids.each { |pid| Process.waitpid2(pid) }
  end

  def scan_domains(domains: [])
    index = domains.first.id
    limit = domains.last.id

    logger = Logger.new(Rails.root.join("log/scan_domains_#{index}_#{limit}.log"))
    failure_logger = Logger.new(Rails.root.join("log/scan_domains_failure_#{Time.now.strftime('%F')}.log"))

    domains.each do |domain|
      log_scan_result(
        scan: scan_domain(domain), index: index, limit: limit, logger: logger, failure_logger: failure_logger
      )

      index += 1
    end
  end

  def log_scan_result(logger: nil, failure_logger: nil, index: nil, limit: nil, scan: nil)
    result = scan.success? ? "succesfully" : "not succesfully"
    logger.info("[#{index} / #{limit}] The domain #{scan.url} has been scanned #{result}\n")

    unless scan.success?
      failure_logger.info("#{index}. #{scan.url}")
      failure_logger.info("  Status: #{scan.status}") if scan.status.present?
      failure_logger.info("  Errors: #{scan.errors}") if scan.errors.present?
    end
  end

  def scan_domain(domain)
    result = Headlines::AnalyzeDomainHeaders.call(url: domain.name)

    if result.success?
      domain.build_last_scan(scan_params(result).merge(domain_id: domain.id))
      domain.save!
    end

    result
  end

  def scan_params(result)
    result[:params].slice(:headers, :results, :score, :http_score, :csp_score)
  end
end
