RAKE_ROOT = File.dirname(__FILE__)
$LOAD_PATH << File.join(RAKE_ROOT, 'tasks')

# Load all tasks
Dir['tasks/**/*.rake'].each { |task| load task }

# Rake
require 'rake/clean'
# Bundler
require "bundler/gem_tasks"

# RSpec
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

# Default task
task :default => :spec
