# frozen_string_literal: true

require 'spec_helper'

describe 'hyperclient-mcp start' do
  let(:cli) { File.expand_path(File.join(__FILE__, '../../../bin/hyperclient-mcp')) }
  let(:token) { ENV.fetch('TOKEN', 'token') }

  def wait_for_http_ok(host, port, timeout_seconds: 10)
    deadline = Time.now + timeout_seconds
    last_error = nil
    until Time.now > deadline
      begin
        Net::HTTP.start(host, port, open_timeout: 0.5, read_timeout: 0.5) do |http|
          res = http.get('/')
          return true if res.is_a?(Net::HTTPOK) && res.body.include?('OK')
        end
      rescue StandardError => e
        last_error = e
      end
      sleep 0.1
    end
    warn "Server did not respond OK in time: #{last_error}"
    false
  end

  context 'with defaults' do
    let(:command) do
      [
        cli,
        '--vcr-cassette-name=sup.playplay.io/api',
        '--api', 'https://sup2.playplay.io/api',
        '--header', "X-Access-Token=#{token}",
        '--header', 'User-agent=HyperclientMCP/1.0',
        'start'
      ]
    end

    it 'starts server' do
      pid = Process.spawn({}, *command, out: $stdout, err: $stderr)

      begin
        expect(wait_for_http_ok('0.0.0.0', '9292', timeout_seconds: 20)).to be(true)

        Process.kill('INT', pid)

        status = nil
        Timeout.timeout(15) { status = Process.wait2(pid)&.last }
        expect(status).to be_exited
      rescue Timeout::Error
        Process.kill('KILL', pid)
      end
    end
  end

  context 'with custom options' do
    let(:command) do
      [
        cli,
        '--vcr-cassette-name=sup.playplay.io/api',
        '--api', 'https://sup2.playplay.io/api',
        '--header', "X-Access-Token=#{token}",
        '--header', 'User-agent=HyperclientMCP/1.0',
        'start',
        '--host', 'localhost',
        '--port', '9393',
        '--name', 'Custom MCP',
        '--version', '0.1.0'
      ]
    end

    it 'starts server' do
      pid = Process.spawn({}, *command, out: $stdout, err: $stderr)

      begin
        expect(wait_for_http_ok('localhost', '9393', timeout_seconds: 20)).to be(true)

        Process.kill('INT', pid)

        status = nil
        Timeout.timeout(15) { status = Process.wait2(pid)&.last }
        expect(status).to be_exited
      rescue Timeout::Error
        Process.kill('KILL', pid)
      end
    end
  end
end
