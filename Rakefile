require 'spec/rake/spectask'

desc 'Run unit tests'
Spec::Rake::SpecTask.new :spec do |t|
  t.spec_files = FileList['spec/**/*.spec.rb']
  t.spec_opts  = %w[--color --format=progress --debugger]
end
