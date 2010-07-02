# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{html2email}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["guns"]
  s.date = %q{2010-07-02}
  s.default_executable = %q{html2email}
  s.description = %q{Convert ruby html templates to an email compatible form.}
  s.email = %q{sung@metablu.com}
  s.executables = ["html2email"]
  s.files = [".gitignore", ".gitmodules", "LICENSE", "README.markdown", "Rakefile", "bin/html2email", "html2email.gemspec", "lib/html2email.rb", "lib/html2email/context.rb", "lib/html2email/html_email.rb", "lib/html2email/html_mailer.rb", "spec/html2email.spec.rb", "lib/html2email/vendor/premailer/.gitignore", "lib/html2email/vendor/premailer/CHANGELOG.rdoc", "lib/html2email/vendor/premailer/LICENSE.rdoc", "lib/html2email/vendor/premailer/README.rdoc", "lib/html2email/vendor/premailer/bin/premailer", "lib/html2email/vendor/premailer/bin/trollop.rb", "lib/html2email/vendor/premailer/init.rb", "lib/html2email/vendor/premailer/lib/premailer.rb", "lib/html2email/vendor/premailer/lib/premailer/html_to_plain_text.rb", "lib/html2email/vendor/premailer/lib/premailer/premailer.rb", "lib/html2email/vendor/premailer/misc/client_support.yaml", "lib/html2email/vendor/premailer/premailer.gemspec", "lib/html2email/vendor/premailer/rakefile.rb", "lib/html2email/vendor/premailer/tests/files/base.html", "lib/html2email/vendor/premailer/tests/files/contact_bg.png", "lib/html2email/vendor/premailer/tests/files/dialect.png", "lib/html2email/vendor/premailer/tests/files/dots_end.png", "lib/html2email/vendor/premailer/tests/files/dots_h.gif", "lib/html2email/vendor/premailer/tests/files/import.css", "lib/html2email/vendor/premailer/tests/files/inc/2009-placeholder.png", "lib/html2email/vendor/premailer/tests/files/noimport.css", "lib/html2email/vendor/premailer/tests/files/styles.css", "lib/html2email/vendor/premailer/tests/test_helper.rb", "lib/html2email/vendor/premailer/tests/test_html_to_plain_text.rb", "lib/html2email/vendor/premailer/tests/test_link_resolver.rb", "lib/html2email/vendor/premailer/tests/test_premailer.rb"]
  s.homepage = %q{http://github.com/guns/html2email}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Html2Email: Tilt + Premailer + SMTP}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>, [">= 0"])
      s.add_runtime_dependency(%q<tilt>, [">= 0"])
      s.add_runtime_dependency(%q<hpricot>, [">= 0.6"])
      s.add_runtime_dependency(%q<css_parser>, [">= 0.9.1"])
      s.add_runtime_dependency(%q<text-reform>, [">= 0.2.0"])
      s.add_runtime_dependency(%q<htmlentities>, [">= 4.0.0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<tilt>, [">= 0"])
      s.add_dependency(%q<hpricot>, [">= 0.6"])
      s.add_dependency(%q<css_parser>, [">= 0.9.1"])
      s.add_dependency(%q<text-reform>, [">= 0.2.0"])
      s.add_dependency(%q<htmlentities>, [">= 4.0.0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<tilt>, [">= 0"])
    s.add_dependency(%q<hpricot>, [">= 0.6"])
    s.add_dependency(%q<css_parser>, [">= 0.9.1"])
    s.add_dependency(%q<text-reform>, [">= 0.2.0"])
    s.add_dependency(%q<htmlentities>, [">= 4.0.0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
