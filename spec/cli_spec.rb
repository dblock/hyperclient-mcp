# frozen_string_literal: true

require 'spec_helper'

describe 'Cli' do
  let(:cli) { File.expand_path(File.join(__FILE__, '../../bin/hyperclient-mcp')) }
  let(:token) { ENV.fetch('TOKEN', 'token') }

  describe '#help' do
    it 'displays help' do
      help = `"#{cli}" help`
      expect(help).to include 'Hypermedia API MCP Server.'
    end
  end

  describe '#resources' do
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

  describe '#start' do
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

    it 'starts server' do
      pid = Process.spawn({}, *command, out: $stdout, err: $stderr)

      begin
        expect(wait_for_http_ok('localhost', '9292', timeout_seconds: 20)).to be(true)

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
