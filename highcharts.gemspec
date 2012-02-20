# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "highcharts/version"

Gem::Specification.new do |s|
  s.name        = "highcharts"
  s.version     = Highcharts::VERSION
  s.authors     = ["Nick Willever"]
  s.email       = ["nickwillever@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Provides an extendable class for charting with high charts}
  s.description = %q{This allows you to extend the charting module into your classes and then use it to create json for highcharts}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'ice_cube', '0.7.7'
end
