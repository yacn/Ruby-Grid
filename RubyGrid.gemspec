# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubygrid/version'

Gem::Specification.new do |s|
  s.name        = 'RubyGrid'
  s.version     = RubyGrid::VERSION
  s.date        = '2013-08-05'
  s.summary     = 'Grid gem for Games or whatever else you can think of'
  s.description = 'A simple gem for grids in Ruby'
  s.authors     = ['Randy Carnahan', 'yacn']
  s.email       = 'admin@yacn.pw'
  s.files       = ['lib/rubygrid.rb', 'lib/rubygrid/version.rb', 'lib/rubygrid/grid.rb']
  s.homepage    = 'https://github.com/yacn/Ruby-Grid'
  s.license     = 'MIT'

  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.3'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-minitest'
end
