require 'spec_helper'

describe 'graphite', :type => :class do
  it { should contain_file('/etc/init.d/carbon-cache').with_ensure('link').
       with_target('/lib/init/upstart-job') }
  it { should contain_file('/etc/init.d/graphite-web').with_ensure('link').
       with_target('/lib/init/upstart-job') }
  it { should contain_file('/opt/graphite/storage').with_owner('www-data').
       with_mode('0775') }
  it { should contain_file('/opt/graphite/storage/whisper').
       with_owner('www-data').with_mode('0775') }

  describe "carbon-cache.conf" do
    let(:params) {{ :root_dir => '/this/is/root' }}
    it { should contain_file('/etc/init/carbon-cache.conf').with_ensure('present').
         with_content(/chdir '\/this\/is\/root'/).
         with_content(/GRAPHITE_STORAGE_DIR='\/this\/is\/root\/storage'/).
         with_content(/GRAPHITE_CONF_DIR='\/this\/is\/root\/conf'/).
         with_content(/python '\/this\/is\/root\/bin\/carbon-cache.py'/).
         with_mode('0555') }
  end

  describe "graphite-web.conf" do
    let(:params) {{ :root_dir => '/this/is/root' }}
    it { should contain_file('/etc/init/graphite-web.conf').with_ensure('present').
         with_content(/chdir '\/this\/is\/root\/webapp'/).
         with_content(/PYTHONPATH='\/this\/is\/root\/webapp'/).
         with_content(/GRAPHITE_STORAGE_DIR='\/this\/is\/root\/storage'/).
         with_content(/GRAPHITE_CONF_DIR='\/this\/is\/root\/conf'/).
         with_mode('0555') }
  end

  describe "carbon.conf" do
    context 'with unconfigured carbon contents' do
      let(:params) {{ :root_dir => '/this/is/root' }}
      it { should contain_file('/this/is/root/conf/carbon.conf').
           with_content(/LOCAL_DATA_DIR = \/this\/is\/root\/storage\/whisper\//) }
      end

    context 'with configured carbon contents' do
      let(:params) {{ :root_dir => '/this/is/root', :carbon_content => 'SOMEVAR=SOMECONTENT' }}
      it { should contain_file('/this/is/root/conf/carbon.conf').with_ensure('present').
           with_content(/SOMECONTENT/) }
    end

  end

  describe "storage-aggregation.conf" do
    context 'with unconfigured storage aggregation' do
      it { should contain_file('/opt/graphite/conf/storage-aggregation.conf').
           with_source(/storage-aggregation\.conf/) }
    end

    context 'with configured storage aggregation' do
      let(:params) { {'storage_aggregation_content' => "Elephants and giraffes!" } }
      it { should contain_file('/opt/graphite/conf/storage-aggregation.conf').
           with_content("Elephants and giraffes!") }
    end
  end

  describe "storage-schemas" do
    context 'with unconfigured storage schemas' do
      it { should contain_file('/opt/graphite/conf/storage-schemas.conf').
           with_source(/storage-schemas\.conf/) }
    end

    context 'with configured storage schemas' do
      let(:params) { {'storage_schemas_content' => "Giraffes and elephants!" } }
      it { should contain_file('/opt/graphite/conf/storage-schemas.conf').
           with_content("Giraffes and elephants!") }
    end
  end

  it {
    should contain_exec('init-db').with_command('/usr/bin/python manage.py syncdb --noinput').
    with_cwd('/opt/graphite/webapp/graphite')
  }

  it {
    should contain_file('/opt/graphite/storage/graphite.db').with_owner('www-data')
  }

  it {
    should contain_file('/opt/graphite/storage/log/webapp/').with_owner('www-data')
  }

  it {
    should contain_file('/opt/graphite/webapp/graphite/local_settings.py').
    with_content(/SOMECONTENT/)
  }

end
