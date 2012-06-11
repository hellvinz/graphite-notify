# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'graphite-notify/version'

Gem::Specification.new do |s|
  s.name        = "graphite-notify"
  s.version     = GraphiteNotify::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vincent Hellot"]
  s.email       = ["hellvinz@gmail.com"]
  s.homepage    = "https://github.com/hellvinz/graphite-notify"
  s.summary     = %q{notify graphite on deploy or rollback}
  s.description = %q{notify graphite on deploy or rollback}

  s.required_ruby_version     = ">= 1.8.7"
  s.required_rubygems_version = ">= 1.3.6"

  git_files            = `git ls-files`.split("\n") rescue ''
  s.files              = git_files
  s.require_paths      = ["lib"]
end
