# frozen_string_literal: true

module Hyperclient
  module Mcp
    module Cli
      class App
        desc 'List resources.'
        command 'resources' do |g|
          g.action do |global, _options, _args|
            global['mcp'].resources.each do |resource|
              puts resource
            end
          end
        end
      end
    end
  end
end
