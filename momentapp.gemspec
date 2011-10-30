# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "momentapp/version"

Gem::Specification.new do |s|
  s.name        = "momentapp"
  s.version     = Momentapp::VERSION
  s.authors     = ["millisami"]
  s.email       = ["millisami@gmail.com"]
  s.homepage    = "http://millisami.github.com/momentapp"
  s.summary     = %q{Moment is a ruby wrapper for the Momentapp.com service.}
  s.description = %q{Moment is a ruby wrapper for the Momentapp.com service. Interaction with the Momentapp API made easy.}

  s.rubyforge_project = "momentapp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
