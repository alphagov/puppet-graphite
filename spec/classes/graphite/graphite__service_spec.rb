require 'spec_helper'

describe 'graphite', :type => :class do
  describe 'param defaults' do
    context 'debian' do
      let(:facts) {{ :osfamily => 'Debian' }}
      it { should contain_service('carbon-aggregator').with_ensure('stopped') }
      it { should contain_service('carbon-cache') }
      it { should contain_service('graphite-web') }
    end
    context 'redhat' do
      let(:facts) {{ :osfamily => 'RedHat' }}
      it { should contain_service('carbon-aggregator').with_ensure('stopped') }
      it { should contain_service('carbon-cache') }
      it { should contain_service('graphite-web') }
    end
  end
  describe 'carbon_aggregator' do
    let(:params) {{ :carbon_aggregator => true }}
    context 'debian' do
      let(:facts) {{ :osfamily => 'Debian' }}
      it { should contain_service('carbon-aggregator').with_ensure('running') }
    end
    context 'redhat' do
      let(:facts) {{ :osfamily => 'RedHat' }}
      it { should contain_service('carbon-aggregator').with_ensure('running') }
    end
  end

end
