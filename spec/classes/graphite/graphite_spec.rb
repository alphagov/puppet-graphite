require 'spec_helper'

describe 'graphite', :type => :class do
  let(:facts) { {:osfamily => 'debian'} }
  it { should contain_package('whisper')}
  it { should contain_package('graphite-web')}
  it { should contain_package('carbon')}
end
