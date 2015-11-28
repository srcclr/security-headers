namespace :headlines do
  desc "Scan existing domains for security vulnerabilities"
  task scan_domains: :environment do
    next if Thread.current[:do_not_perfom_twice]
    Thread.current[:do_not_perfom_twice] = true

    pids = []

    Headlines::Domain.find_in_batches(batch_size: 2_500) do |domains|
      pids.push(fork { Headlines::ScanDomains::Runner.new(domains).call })
    end

    trap("SIGINT") { pids.each { |pid| Process.kill("SIGINT", pid) } }
    pids.each { |pid| Process.waitpid2(pid) }
  end
end
