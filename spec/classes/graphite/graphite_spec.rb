require 'spec_helper'

describe 'graphite', :type => :class do

  context 'osfamily => debian' do
    let(:facts) {{ :osfamily => 'Debian' }}
    it { should create_class('graphite::config')}
    it { should create_class('graphite::install')}
    it { should create_class('graphite::service')}
    it { should contain_class('graphite::deps') }
  end

  context 'osfamily => redhat' do
    let(:facts) {{ :osfamily => 'RedHat' }}
    it { should create_class('graphite::config')}
    it { should create_class('graphite::install')}
    it { should create_class('graphite::service')}
    it { should contain_class('graphite::deps') }
  end

  context 'osfamily => Suse' do
    let(:facts) {{ :osfamily => 'Suse' }}
    it { expect { should contain_class('graphite') }.to raise_error(Puppet::Error) }
  end

  context 'osfamily => Solaris' do
    let(:facts) {{ :osfamily => 'Solaris' }}
    it { expect { should contain_class('graphite') }.to raise_error(Puppet::Error) }
  end
  context 'osfamily => Gentoo' do
    let(:facts) {{ :osfamily => 'Gentoo' }}
    it { expect { should contain_class('graphite') }.to raise_error(Puppet::Error) }
  end

  context 'osfamily => Archlinux' do
    let(:facts) {{ :osfamily => 'Archlinux' }}
    it { expect { should contain_class('graphite') }.to raise_error(Puppet::Error) }
  end

  context 'osfamily => Mandrake' do
    let(:facts) {{ :osfamily => 'Mandrake' }}
    it { expect { should contain_class('graphite') }.to raise_error(Puppet::Error) }
  end

end
