# frozen_string_literal: true

require 'spec_helper'

describe 'hyperclient-mcp resources' do
  let(:cli) { File.expand_path(File.join(__FILE__, '../../../bin/hyperclient-mcp')) }
  let(:token) { ENV.fetch('TOKEN', 'token') }

  let(:command) do
    "\"#{cli}\" --vcr-cassette-name=sup.playplay.io/api " \
      '--api https://sup2.playplay.io/api ' \
      "--header X-Access-Token=#{token} " \
      '--header User-agent=HyperclientMCP/1.0 ' \
      'resources ' \
      '2>&1'
  end

  it 'lists resources' do
    output = `#{command}`.split
    expect(output).to include 'Hyperclient::Mcp::Resources::Root'
    expect(output).to include 'Hyperclient::Mcp::Resources::Status'
  end
end
