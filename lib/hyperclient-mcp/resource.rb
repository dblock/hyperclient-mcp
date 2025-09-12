module Hyperclient
  module Mcp
    class Resource < FastMcp::Resource
      %i[api key link].each do |f|
        self.class.send :define_method, f do |val|
          instance_variable_set "@#{f}", val
        end

        send :define_method, f do
          self.class.instance_variable_get("@#{f}")
        end
      end

      # class << self
      #   def inspect
      #     "#<Class:#{object_id} uri=#{uri}, name=#{resource_name}>"
      #   end
      # end
    end
  end
end
