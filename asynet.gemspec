# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "asynet/version"

Gem::Specification.new do |s|
  s.name        = "asynet"
  s.version     = Asynet::VERSION
  s.authors     = ["gussan"]
  s.email       = ["gussan@gussan.net"]
  s.homepage    = "http://github.com/gussan/asynet"
  s.summary     = %q{Asynet: text protocol stress testing tool}
  s.description = %q{text protocol stress testing tool}

  s.rubyforge_project = "asynet"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "em-synchrony"

  # for development
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "webmock"
  s.add_development_dependency "pry"

  if RUBY_PLATFORM =~ /darwin/
    s.add_development_dependency "growl"
  end
end
