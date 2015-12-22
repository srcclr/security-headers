module Headlines
  class Engine < ::Rails::Engine
    isolate_namespace Headlines

    config.generators do |generate|
      generate.test_framework :rspec, fixture: false
      generate.fixture_replacement :factory_girl, dir: "spec/factories"
      generate.assets false
      generate.helper false
    end

    paths["lib/tasks"] << "lib/engine_tasks"
  end
end
