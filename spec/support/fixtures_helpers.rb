module FixturesHelpers
  def open_fixture(file_path)
    File.open(path_to_fixture(file_path))
  end

  def path_to_fixture(file_path)
    File.join(File.expand_path("../fixtures", __FILE__), file_path)
  end
end

RSpec.configure do |config|
  config.include FixturesHelpers
end
