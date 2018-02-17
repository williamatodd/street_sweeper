$LOAD_PATH.unshift 'lib'

require './lib/version.rb'

Gem::Specification.new do |s|
  s.name = 'street_sweeper'
  s.licenses = ['MIT']
  s.version = StreetSweeper::VERSION
  s.date = Time.now.strftime('%Y-%m-%d')
  s.summary = 'Parse Addresses into substituent parts. This gem includes US only.'
  s.authors = ['William Todd']
  s.require_paths = ['lib']
  s.email = 'bill@investinwaffles.com'
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
  s.homepage = 'https://github.com/williamatodd/street_sweeper'
  s.description = <<desc
StreetSweeper allows you to send any string to parse and if the string is a US address returns an object of the address broken into it's substituent parts.

A port of Geo::StreetAddress::US by Schuyler D. Erle and Tim Bunce, which in turn was forked from Derrek Long's StreetAddress::US into this gem.
desc

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
end
