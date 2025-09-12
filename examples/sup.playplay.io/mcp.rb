require 'sinatra'
require 'hyperclient-mcp'
require 'puma'

api = Hyperclient.new('https://sup2.playplay.io/api') do |client|
  client.headers['X-Access-Token'] = ENV.fetch('TOKEN', nil)
end

hyperclient_mcp = Hyperclient::Mcp::Api.new(api)

mcp_server = FastMcp::Server.new(name: "S'Up", version: '0.0.1')
mcp_server.register_resources(*hyperclient_mcp.resources)

use FastMcp::Transports::RackTransport, mcp_server

get '/' do
  'Hello World!'
end
