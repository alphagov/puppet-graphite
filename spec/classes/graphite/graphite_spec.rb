require 'spec_helper'

describe 'graphite', :type => :class do
  let(:facts) { {:osfamily => 'debian'} }
  it { should create_class('graphite::config')}
  it { should create_class('graphite::install')}
  it { should create_class('graphite::service')}

  it { should contain_package('whisper')}
  it { should contain_exec('graphite/install carbon')}
  it { should contain_exec('graphite/install graphite-web')}
  it { should contain_package('gunicorn')}

  it { should contain_service('carbon-cache') }
  it { should contain_service('graphite-web') }

  context 'with admin password' do
    let(:params) { {'admin_password' => 'should be a hash' }}
    it { should contain_file('/opt/graphite/webapp/graphite/initial_data.json').with_content(/should be a hash/) }
  end

  context 'with different root dir' do
    let(:params) { {'root_dir' => '/var/lib/graphite' }}
    it { should contain_file('/var/lib/graphite/webapp/graphite/initial_data.json') }
  end

  context 'with unconfigured storage schemas' do
    it {
      should contain_file('/opt/graphite/conf/storage-schemas.conf').
        with_source(/storage-schemas\.conf/)
    }
  end

  context 'with configured storage schemas' do
    let(:params) { {'storage_schemas_content' => "Giraffes and elephants!" } }
    it {
      should contain_file('/opt/graphite/conf/storage-schemas.conf').
        with_content("Giraffes and elephants!")
    }
  end

  context 'with unconfigured storage aggregation' do
    it {
      should contain_file('/opt/graphite/conf/storage-aggregation.conf').
        with_source(/storage-aggregation\.conf/)
    }
  end

  context 'with configured storage aggregation' do
    let(:params) { {'storage_aggregation_content' => "Elephants and giraffes!" } }
    it {
      should contain_file('/opt/graphite/conf/storage-aggregation.conf').
        with_content("Elephants and giraffes!")
    }
  end

end
