# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../spec/dummy/db/migrate", __FILE__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../../db/migrate", __FILE__)
