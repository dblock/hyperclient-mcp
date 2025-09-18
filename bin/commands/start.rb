# frozen_string_literal: true

module Hyperclient
  module Mcp
    module Cli
      class App
        desc 'Start an MCP server.'
        command 'start' do |command|
          command.flag 'h', 'host', desc: 'server host', type: String, default_value: '0.0.0.0'
          command.flag 'p', 'port', desc: 'server port', type: Integer, default_value: 9292
          command.flag 'n', 'name', desc: 'mcp server name', type: String, default_value: 'Hyperclient MCP'
          command.flag 'v', 'version', desc: 'mcp server version', type: String, default_value: '0.0.1'
          command.action do |global, options, _args|
            require 'sinatra'
            require 'puma'
            require 'rack/handler/puma'

            mcp_server = FastMcp::Server.new(name: options['name'], version: options['version'])
            mcp_server.register_resources(*global['mcp'].resources)

            app = Class.new(Sinatra::Base) do
              set :environment, ENV.fetch('RACK_ENV', 'development')

              use FastMcp::Transports::RackTransport, mcp_server

              get '/' do
                'OK'
              end
            end

            host = options['host'] || ENV.fetch('HOST', '0.0.0.0')
            port = options['port'] || Integer(ENV.fetch('PORT', 9292))

            Rack::Handler::Puma.run(app, Host: host, Port: port)
          end
        end
      end
    end
  end
end
