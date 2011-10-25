# -*- encoding: utf-8 -*-
require 'rake'
$:.push File.expand_path("../lib", __FILE__)
require "agent_orange/version"

Gem::Specification.new do |s|
  s.name        = "agent_orange"
  s.version     = AgentOrange::VERSION
  s.authors     = ["Kevin Elliott"]
  s.email       = ["kevin@welikeinc.com"]
  s.homepage    = "http://github.com/kevinelliott/agent_orange"
  s.summary     = %q{Parse and process User Agents like a secret one}
  s.description = %q{Parse and process User Agents like a secret one}

  s.rubyforge_project = "agent_orange"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "bundler"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
