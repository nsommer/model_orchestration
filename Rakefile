require 'rake/testtask'
require 'rdoc/task'

task :default => [:test]

Rake::TestTask.new do |test|
  test.libs << 'test'
  test.test_files = Dir['test/**/*_test.rb']
end

RDoc::Task.new do |rdoc|
  rdoc.title = "ModelOrchestration documentation"
  rdoc.main = "README.rdoc"
  rdoc.rdoc_files.include("README.rdoc", "lib/**/*.rb")
  rdoc.rdoc_dir = "docs"
end