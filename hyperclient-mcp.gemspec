# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'hyperclient-mcp/version'

Gem::Specification.new do |s|
  s.name = 'hyperclient-mcp'
  s.bindir = 'bin'
  s.version = Hyperclient::Mcp::VERSION
  s.authors = ['Daniel Doubrovkine']
  s.email = 'dblock@dblock.org'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0'
  s.required_rubygems_version = '>= 2.5'
  s.files = Dir['{bin,lib}/**/*'] + ['README.md', 'LICENSE.md', 'CHANGELOG.md']
  s.require_paths = ['lib']
  s.homepage = 'http://github.com/dblock/hyperclient-mcp'
  s.licenses = ['MIT']
  s.summary = 'Turn any Hypermedia api into an mcp server.'
  s.add_dependency 'fast-mcp'
  s.add_dependency 'gli'
  s.add_dependency 'hyperclient'
  s.add_dependency 'puma'
  s.add_dependency 'sinatra'
  s.metadata['rubygems_mfa_required'] = 'true'
end
