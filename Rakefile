require 'bundler/gem_tasks'
require 'rake/dsl_definition'
Dir.glob('./lib/tasks/*.rake').each { |r| import r }

begin
  require 'rspec/core/rake_task'

  desc "Run all specs"
  RSpec::Core::RakeTask.new do |t|
    # t.pattern = "./spec/**/*_spec.rb" # don't need this, it's default.
    # Put spec opts in a file named .rspec in root
  end
  task :default => :spec
end