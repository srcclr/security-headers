require "tempfile"

module Headlines
  class DomainsArchive
    BASENAME = "top-1m.csv"
    URL = "http://s3.amazonaws.com/alexa-static/#{BASENAME}.zip"

    attr_reader :tmp_archive, :tmp_domains
    private :tmp_archive, :tmp_domains

    delegate :each_line, :eof?, :lineno, to: :archive

    def initialize
      @tmp_archive = Tempfile.new("#{BASENAME}.zip")
      @tmp_domains = Tempfile.new(BASENAME)
    end

    private

    def archive
      @archive ||= extract_domains
    end

    def extract_domains
      download_archive

      ::Zip::File.open(tmp_archive.path) do |file|
        tmp_domains.binmode
        tmp_domains.write(file.get_entry(BASENAME).get_input_stream.read)
      end

      tmp_domains.rewind && tmp_domains
    end

    def download_archive
      response = ::Faraday.get(URL)
      tmp_archive.write(response.body.force_encoding("utf-8"))

      tmp_archive.rewind
    end
  end
end
