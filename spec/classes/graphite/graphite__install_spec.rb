require 'spec_helper'

describe 'graphite', :type => :class do
  let(:version) { '0.9.12' }

  it { should contain_exec('graphite/install carbon').
       with_command("/usr/bin/pip install --install-option=\"--prefix=/opt/graphite\" --install-option=\"--install-lib=/opt/graphite/lib\" carbon==#{version}") }
  it { should contain_exec('graphite/install graphite-web').
       with_command("/usr/bin/pip install --install-option=\"--prefix=/opt/graphite\" --install-option=\"--install-lib=/opt/graphite/webapp\" graphite-web==#{version}") }
end
