namespace :headlines do
  PROCESS_COUNT = 8
  DEFAULT_BATCH = 2_500

  def batch_size
    [Headlines::Domain.count.fdiv(PROCESS_COUNT).ceil, DEFAULT_BATCH].max
  end

  desc "Scan existing domains for security vulnerabilities"
  task scan_domains: :environment do
    next if Thread.current[:do_not_perfom_twice]
    Thread.current[:do_not_perfom_twice] = true
    pids = []

    Headlines::Domain.find_in_batches(batch_size: batch_size) do |domains|
      pids.push(fork { Headlines::ScanDomains::Runner.new(domains).call })
    end

    trap("SIGINT") { pids.each { |pid| Process.kill("SIGINT", pid) } }
    pids.each { |pid| Process.waitpid2(pid) }
  end
end
