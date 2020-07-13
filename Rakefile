# frozen_string_literal: true

require 'rake'
require 'rspec/core/rake_task'
require 'captive/version'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation'
end

task :build do
  system 'gem build captive.gemspec'
end

task release: :build do
  system "gem push captive-#{Captive::VERSION}.gem"
end

task default: :spec
