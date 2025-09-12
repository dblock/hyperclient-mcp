require 'spec_helper'

describe Hyperclient::Mcp::Api do
  let(:client) do
    Hyperclient.new('http://example.org/api')
  end

  let!(:api) { Hyperclient::Mcp::Api.new(client) }

  describe '#api', vcr: { cassette_name: 'grape-with-roar/api' } do
    it 'fetches resources' do
      expect(api.resources.count).to eq 4
    end

    context 'root' do
      let(:resource) { api.resources.first }

      it 'is a Hyperclient::Mcp::Resource::Root' do
        expect(resource).to be < Hyperclient::Mcp::Resource
        expect(resource.to_s).to start_with 'Hyperclient::Mcp::Resources::Root'
        expect(resource.name).to eq 'root'
      end
    end

    context 'spline' do
      let(:resource) { api.resources.last }

      it 'is a Hyperclient::Mcp::Resource::Spline' do
        expect(resource).to be < Hyperclient::Mcp::Resource
        expect(resource.to_s).to start_with 'Hyperclient::Mcp::Resources::Spline'
        expect(resource.name).to eq 'spline'
        expect(resource.template_variables).to eq ['uuid']
      end
    end
  end
end
