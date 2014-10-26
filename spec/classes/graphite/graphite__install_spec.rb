require 'spec_helper'

shared_examples "pip_package" do |package|
  it { should contain_python__pip("#{package}==1.2.3").
       with_virtualenv('/this/is/root').
       with_environment(["PYTHONPATH=/this/is/root/lib:/this/is/root/webapp"]) }
end

describe 'graphite', :type => :class do

  context 'use python pip' do
    context 'root_dir and version' do
      let(:params) {{
        :version  => '1.2.3',
        :root_dir => '/this/is/root',
      }}

      it_should_behave_like "pip_package", "whisper"
      it_should_behave_like "pip_package", "carbon"
      it_should_behave_like "pip_package", "graphite-web"
    end
  end

  context 'use package' do
    let(:params) {{
      :use_python_pip => false,
      :version => '1.2.3',
      :whisper_pkg_name => 'python-whisper',
      :carbon_pkg_name => 'python-carbon',
      :graphite_web_pkg_name => 'python-graphite-web',
    }}

    it { should contain_package('python-whisper').with_ensure('1.2.3') }
    it { should contain_package('python-carbon').with_ensure('1.2.3') }
    it { should contain_package('python-graphite-web').with_ensure('1.2.3') }
  end

end
