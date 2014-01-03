require 'spec_helper'

describe 'graphite', :type => :class do
  let(:facts) { {:osfamily => 'debian'} }
  it { should create_class('graphite::config')}
  it { should create_class('graphite::install')}
  it { should create_class('graphite::service')}

  it { should contain_class('graphite::deps') }
end
