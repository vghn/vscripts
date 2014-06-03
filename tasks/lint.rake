namespace 'lint' do
  require 'reek/rake/task'
  desc 'Run Reek on the lib directory'
  Reek::Rake::Task.new do |task|
    task.fail_on_error = false
    task.verbose = false
    task.reek_opts = '--quiet'
  end

  require 'rubocop/rake_task'
  desc 'Run RuboCop on the lib directory'
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = ['lib/**/*.rb']
    task.fail_on_error = false
  end
end

desc 'Run all lint tests'
task :lint do
  Rake::Task['lint:reek'].invoke
  Rake::Task['lint:rubocop'].invoke
end
