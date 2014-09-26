require 'spec_helper'

shared_examples "pip_package" do |package|
  it { should contain_python__pip("#{package}==1.2.3").
       with_virtualenv('/this/is/root').
       with_environment(["PYTHONPATH=/this/is/root/lib:/this/is/root/webapp"]) }
end

describe 'graphite', :type => :class do
  describe 'root_dir and version' do
    let(:params) {{
      :version  => '1.2.3',
      :root_dir => '/this/is/root',
    }}
    context 'debian' do
      let(:facts) {{ :osfamily => 'Debian' }}
      it_should_behave_like "pip_package", "whisper"
      it_should_behave_like "pip_package", "carbon"
      it_should_behave_like "pip_package", "graphite-web"
    end
    context 'redhat' do
      let(:facts) {{ :osfamily => 'RedHat' }}
      it_should_behave_like "pip_package", "whisper"
      it_should_behave_like "pip_package", "carbon"
      it_should_behave_like "pip_package", "graphite-web"
    end
  end
end
