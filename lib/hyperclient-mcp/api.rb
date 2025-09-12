module Hyperclient
  module Mcp
    class Api
      attr_reader :api

      def initialize(api)
        @api = api
      end

      def resources
        @resources ||= _resources(@api)
      end

      private

      def _resources(api, name = 'root')
        api._links.map do |key, link|
          name = key unless key == 'self'

          href = link.instance_variable_get('@link')['href'].gsub(api.to_s, '')

          klass = Class.new(Hyperclient::Mcp::Resource) do
            uri "api://#{href}" # TODO: configure api prefix
            resource_name name
            mime_type 'application/json'
            api api
            key key
            link link

            def content
              JSON.generate(
                api.send(
                  key, params
                )._resource._attributes.to_h
              )
            end
          end

          # Assign a stable constant name like Hyperclient::Mcp::Resources::<CamelizedName>
          const_module = Hyperclient::Mcp.const_defined?(:Resources) ? Hyperclient::Mcp::Resources : Hyperclient::Mcp.const_set(:Resources, Module.new)
          const_name = name.to_s
                           .gsub(/[^a-zA-Z0-9]+/, '_')
                           .split('_')
                           .reject(&:empty?)
                           .map { |part| part[0].upcase + part[1..].to_s.downcase }
                           .join
          const_name = 'Root' if const_name.empty?

          # Avoid collisions by appending a numeric suffix if needed
          candidate = const_name
          suffix = 2
          while const_module.const_defined?(candidate)
            candidate = "#{const_name}#{suffix}"
            suffix += 1
          end
          const_module.const_set(candidate, klass)

          klass.class_eval do
            @api = api
            @key = key
          end

          klass
        end
      end
    end
  end
end
