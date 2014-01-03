require 'spec_helper'

describe 'graphite', :type => :class do

  context 'root_dir' do
    let(:params) {{
      :root_dir => '/this/is/root',
    }}

    it { should contain_python__virtualenv('/this/is/root') }
    it { should contain_python__pip('gunicorn').with_virtualenv('/this/is/root') }

    it { should contain_package('python-cairo').with_ensure('present') }
    it { should contain_file('/this/is/root/lib/python2.7/site-packages/cairo').
         with_ensure('link').
         with_target('/usr/lib/python2.7/dist-packages/cairo').
         with_require(['Python::Virtualenv[/this/is/root]', 'Package[python-cairo]']) }
  end
end
