require 'hyperclient-mcp'
require 'sinatra'
require 'puma'

class Server < Sinatra::Base
  api = Hyperclient.new('http://localhost:9292/api')

  hyperclient_mcp = Hyperclient::Mcp::Api.new(api)

  mcp_server = FastMcp::Server.new(name: 'Grape with Roar', version: '0.0.1')
  mcp_server.register_resources(*hyperclient_mcp.resources)

  use FastMcp::Transports::RackTransport, mcp_server

  get '/' do
    'Hello World!'
  end
end
