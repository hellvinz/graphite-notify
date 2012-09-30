#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'spec/rake/spectask'
require 'yard'

Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.spec_files = FileList['spec/*_spec.rb']
  spec.spec_opts = ['--options', 'spec/spec.opts']
end

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
end
