require 'hyperclient'

api = Hyperclient.new('https://sup2.playplay.io/api') do |client|
  client.headers['X-Access-Token'] = ENV.fetch('TOKEN', nil)
end

status = api.status
puts "Bot is #{status.ping['presence']['presence']}."

team = api.team(id: '64124ac95d758400015faecf')
puts "Team name is #{team.name}."
