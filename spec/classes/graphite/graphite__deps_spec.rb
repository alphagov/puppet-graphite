require 'spec_helper'

describe 'graphite', :type => :class do
  let(:params) {{:root_dir => '/this/is/root'}}

  describe 'virtualenv root_dir' do
    context 'debian' do
      let(:facts) {{ :osfamily => 'Debian' }}
      it { should contain_python__virtualenv('/this/is/root') }
    end
    context 'redhat' do
      let(:facts) {{ :osfamily => 'RedHat' }}
      it { should contain_python__virtualenv('/this/is/root') }
    end
  end

  describe 'web server' do
    context 'debian' do
      let(:facts) {{ :osfamily => 'Debian' }}
      it { should contain_python__pip('gunicorn').with_virtualenv('/this/is/root') }
    end
    context 'redhat' do
      let(:facts) {{ :osfamily => 'RedHat' }}
      it { should contain_python__pip('gunicorn').with_virtualenv('/this/is/root') }
    end
  end

  describe 'cairo' do
    context 'debian' do
      let(:facts) {{ :osfamily => 'Debian' }}
      it { should contain_package('python-cairo').with_ensure('present') }
    end
    context 'redhat' do
      let(:facts) {{ :osfamily => 'RedHat' }}
      it { should contain_package('pycairo').with_ensure('present') }
    end
  end

  describe 'cairo symlink' do
    context 'debian' do
      let(:facts) {{ :osfamily => 'Debian' }}
      it { should contain_file('/this/is/root/lib/python2.7/site-packages/cairo').
        with_ensure('link').
        with_target('/usr/lib/python2.7/dist-packages/cairo').
        with_require(['Python::Virtualenv[/this/is/root]', 'Package[python-cairo]']) }
    end
    context 'redhat' do
      let(:facts) {{ :osfamily => 'RedHat', :operatingsystemmajrelease => 7, :architecture => 'x86_64' }}
      it { should contain_file('/this/is/root/lib/python2.7/site-packages/cairo').
        with_ensure('link').
        with_target('/usr/lib64/python2.7/site-packages/cairo').
        with_require(['Python::Virtualenv[/this/is/root]', 'Package[pycairo]']) }
    end
  end
end
