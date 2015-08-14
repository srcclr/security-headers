namespace :headlines do
  namespace :scans do
    desc "Refresh domain scan scores"
    task refresh_scores: :environment do
      header = Struct.new(:name, :score)

      Headlines::Scan.find_each do |scan|
        score = Headlines::GenerateScanResultsHash.call(
          headers: scan.results.map { |(name, value)| header.new(name, value.to_i) }
        ).score

        scan.update_attributes!(score: score)
      end
    end
  end
end
