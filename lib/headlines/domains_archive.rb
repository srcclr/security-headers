require "tempfile"

module Headlines
  class DomainsArchive
    BASENAME = "top-1m.csv"
    URL = "http://s3.amazonaws.com/alexa-static/#{BASENAME}.zip"

    attr_reader :tmp_arhicve, :tmp_domains
    private :tmp_arhicve, :tmp_domains

    delegate :each_line, to: :extract_domains

    def initialize
      @tmp_arhicve = Tempfile.new("#{BASENAME}.zip")
      @tmp_domains = Tempfile.new(BASENAME)
    end

    private

    def extract_domains
      download_archive

      ::Zip::File.open(tmp_arhicve.path) do |file|
        tmp_domains.binmode
        tmp_domains.write(file.get_entry(BASENAME).get_input_stream.read)
      end

      tmp_domains.rewind && tmp_domains
    end

    def download_archive
      response = ::Faraday.get(URL)
      tmp_arhicve.write(response.body)

      tmp_arhicve.rewind
    end
  end
end
