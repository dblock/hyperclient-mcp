require 'spec_helper'

describe Hyperclient::Mcp::Resource do
  let(:api_obj) { double('api') }
  let(:link_obj) { double('link') }

  context 'inheritance' do
    it 'inherits from FastMcp::Resource' do
      expect(described_class < FastMcp::Resource).to be true
    end
  end

  context 'configuration via class methods' do
    subject(:resource_instance) { resource_class.new }

    let(:resource_class) do
      Class.new(described_class) do
        api :the_api
        key :the_key
        link :the_link
      end
    end

    it 'exposes api from class to instances' do
      expect(resource_instance.api).to eq(:the_api)
    end

    it 'exposes key from class to instances' do
      expect(resource_instance.key).to eq(:the_key)
    end

    it 'exposes link from class to instances' do
      expect(resource_instance.link).to eq(:the_link)
    end
  end

  context 'default values' do
    it 'returns nils when not configured' do
      klass = Class.new(described_class)
      instance = klass.new
      expect(instance.api).to be_nil
      expect(instance.key).to be_nil
      expect(instance.link).to be_nil
    end
  end

  context 'isolation between subclasses' do
    it 'keeps configuration per subclass' do
      a = Class.new(described_class) do
        api :api_a
        key :key_a
        link :link_a
      end

      b = Class.new(described_class) do
        api :api_b
        key :key_b
        link :link_b
      end

      expect(a.new.api).to eq(:api_a)
      expect(a.new.key).to eq(:key_a)
      expect(a.new.link).to eq(:link_a)

      expect(b.new.api).to eq(:api_b)
      expect(b.new.key).to eq(:key_b)
      expect(b.new.link).to eq(:link_b)
    end
  end
end
