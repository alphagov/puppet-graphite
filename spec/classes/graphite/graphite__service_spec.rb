require 'spec_helper'

describe 'graphite', :type => :class do
  context 'param defaults' do
    it { should contain_service('carbon-aggregator').with_ensure('stopped') }
    it { should contain_service('carbon-cache') }
    it { should contain_service('graphite-web') }
  end

  context 'carbon_aggregator' do
    let(:params) {{
      :carbon_aggregator => true,
    }}

    it { should contain_service('carbon-aggregator').with_ensure('running') }
  end
end
