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

    domains.each do |domain|
      log_scan_result(scan: scan_domain(domain), index: index, limit: limit, logger: logger)
      index += 1
    end
  end

  def log_scan_result(logger: nil, index: nil, limit: nil, scan: nil)
    result = scan.success? ? "succesfully" : "not succesfully"
    logger.info("[#{index} / #{limit}] The domain #{scan.url} has been scanned #{result}\n")
  end

  def scan_domain(domain)
    result = Headlines::AnalyzeDomainHeaders.call(url: domain.name)

    if result.success?
      domain.scans.create!(headers: result.params,
                           results: result.scan_results,
                           score: result.score)
    end

    result
  end
end
