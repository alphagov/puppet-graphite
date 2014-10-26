require 'spec_helper'

describe 'graphite', :type => :class do
  let(:facts) { {:osfamily => 'debian'} }

  context 'default params' do
    it { should create_class('graphite::config')}
    it { should create_class('graphite::install')}
    it { should create_class('graphite::service')}

    it { should contain_class('graphite::deps') }
  end

  context "manage user" do
    let(:params) {{ :manage_user => true }}

    it { should create_class('graphite::user')}
  end

  context 'use_python_pip is false' do
    let(:params) {{ :use_python_pip => false }}

    it { should_not create_class('graphite::deps') }
  end

end
