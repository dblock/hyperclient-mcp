# frozen_string_literal: true

module Hyperclient
  module Mcp
    module Cli
      class App
        desc 'Start an MCP server.'
        command 'start' do |g|
          g.action do |global, _options, _args|
            require 'sinatra'
            require 'puma'
            require 'rack/handler/puma'

            # TODO: extract name and version dynamically
            mcp_server = FastMcp::Server.new(name: 'MCP', version: '0.0.1')
            mcp_server.register_resources(*global['mcp'].resources)

            app = Class.new(Sinatra::Base) do
              set :environment, ENV.fetch('RACK_ENV', 'development')

              use FastMcp::Transports::RackTransport, mcp_server

              get '/' do
                'OK'
              end
            end

            # TODO: add arguments
            host = ENV.fetch('HOST', '0.0.0.0')
            port = Integer(ENV.fetch('PORT', '9292'))

            Rack::Handler::Puma.run(app, Host: host, Port: port)
          end
        end
      end
    end
  end
end
