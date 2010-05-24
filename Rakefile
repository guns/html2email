require 'spec/rake/spectask'
require File.expand_path '../lib/html2email', __FILE__

### Helpers

verbose false

def gemspec
  Gem::Specification.new do |gem|
    gem.name        = (@name = 'html2email')
    gem.version     = Html2Email::VERSION
    gem.author      = 'guns'
    gem.email       = 'sung@metablu.com'
    gem.homepage    = 'http://github.com/guns/html2email'
    gem.summary     = 'Html2Email: Tilt + Premailer + SMTP'
    gem.description = 'Convert ruby html templates to an email compatible form.'
    gem.executables = ['html2email']
    gem.files = %x{git ls-files}.split("\n").reject { |f| f[/vendor/] } +
                %x{cd #{base = 'lib/html2email/vendor/premailer'}; git ls-files}
                .split("\n").map { |f| "#{base}/#{f}" }
    gem.add_dependency 'rack'
    gem.add_dependency 'tilt'
    # Premailer
    gem.add_dependency 'hpricot', '>= 0.6'
    gem.add_dependency 'css_parser', '>= 0.9.1'
    gem.add_dependency 'text-reform', '>= 0.2.0'
    gem.add_dependency 'htmlentities', '>= 4.0.0'
    # gem.add_development_dependency 'rspec'
  end
end

### Tasks

task :default => :build

desc 'Run unit tests'
Spec::Rake::SpecTask.new :spec do |t|
  t.spec_files = FileList['spec/**/*.spec.rb']
  t.spec_opts  = %w[--color --format=progress --debugger]
end

desc 'Write gemspec and build gem'
task :build => :spec do
  if (spec = gemspec).respond_to? :to_ruby
    puts "### New gemspec: #{specfile = "#{@name}.gemspec"}"
    File.open(specfile, 'w') { |f| f.write(spec.to_ruby) }
  end
  gemfile = Gem::Builder.new(spec) { |pkg| pkg.need_tar = true }.build
  puts "### New gem: #{gemfile}"
  mkdir_p 'pkg'; mv gemfile, (@gem = "pkg/#{@gemfile}")
end

desc 'Install gem'
task :install => :build do
  puts "### Installing #{@gem}:"
  system 'gem', 'install', @gem
end
