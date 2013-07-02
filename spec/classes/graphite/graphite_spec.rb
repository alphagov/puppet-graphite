require 'spec_helper'

describe 'graphite', :type => :class do
  let(:facts) { {:osfamily => 'debian'} }
  it { should create_class('graphite::config')}
  it { should create_class('graphite::install')}
  it { should create_class('graphite::service')}

  it { should contain_package('python-virtualenv')}
  it { should contain_exec('graphite/install carbon')}
  it { should contain_exec('graphite/install whisper')}
  it { should contain_exec('graphite/install graphite-web')}

  it { should contain_service('carbon') }
  it { should contain_service('graphite-web') }

  context 'with admin password' do
    let(:params) { {'admin_password' => 'should be a hash' }}
    it { should contain_file('/opt/graphite/webapp/graphite/initial_data.json').with_content(/should be a hash/) }
  end

  context 'with different root dir' do
    let(:params) { {'root_dir' => '/var/lib/graphite' }}
    it { should contain_file('/var/lib/graphite/webapp/graphite/initial_data.json') }
  end

end
