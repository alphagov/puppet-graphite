require 'spec_helper'

describe 'graphite', :type => :class do
  let(:facts) { {:osfamily => 'Debian'} }

  it { should contain_file('/etc/init.d/carbon-aggregator').with_ensure('link').
       with_target('/lib/init/upstart-job') }
  it { should contain_file('/etc/init.d/carbon-cache').with_ensure('link').
       with_target('/lib/init/upstart-job') }
  it { should contain_file('/etc/init.d/graphite-web').with_ensure('link').
       with_target('/lib/init/upstart-job') }

  it do should contain_exec('set_graphite_ownership').with(
    'before'  => [ 'Service[graphite-web]', 'Service[carbon-cache]' ],
    'refreshonly' => 'true'
  )
  end

  context "root_dir" do
    let(:params) {{ :root_dir => '/this/is/root' }}

    describe "intial_data.json" do
      it { should contain_file('/this/is/root/webapp/graphite/initial_data.json') }
    end

    describe "carbon-aggregator.conf" do
      it { should contain_file('/etc/init/carbon-aggregator.conf').with_ensure('present').
           with_content(/setuid www-data/).
           with_content(/setgid www-data/).
           with_content(/chdir '\/this\/is\/root'/).
           with_content(/GRAPHITE_STORAGE_DIR='\/this\/is\/root\/storage'/).
           with_content(/GRAPHITE_CONF_DIR='\/this\/is\/root\/conf'/).
           with_content(/exec \/this\/is\/root\/bin\/carbon-aggregator.py/).
           with_mode('0444') }
    end

    describe "carbon-cache.conf" do
      it { should contain_file('/etc/init/carbon-cache.conf').with_ensure('present').
           with_content(/setuid www-data/).
           with_content(/setgid www-data/).
           with_content(/chdir '\/this\/is\/root'/).
           with_content(/GRAPHITE_STORAGE_DIR='\/this\/is\/root\/storage'/).
           with_content(/GRAPHITE_CONF_DIR='\/this\/is\/root\/conf'/).
           with_content(/exec \/this\/is\/root\/bin\/carbon-cache.py/).
           with_mode('0444') }
    end

    describe "graphite-web.conf" do
      it { should contain_file('/etc/init/graphite-web.conf').with_ensure('present').
           with_content(/setuid www-data/).
           with_content(/setgid www-data/).
           with_content(/chdir '\/this\/is\/root\/webapp'/).
           with_content(/PYTHONPATH='\/this\/is\/root\/lib:\/this\/is\/root\/webapp'/).
           with_content(/GRAPHITE_STORAGE_DIR='\/this\/is\/root\/storage'/).
           with_content(/GRAPHITE_CONF_DIR='\/this\/is\/root\/conf'/).
           with_content(/-b127\.0\.0\.1:8000/).
           with_mode('0444') }
    end

    describe "carbon.conf" do
      it { should contain_file('/this/is/root/conf/carbon.conf').
           with_content(/USER = www-data/).
           with_content(/MAX_CACHE_SIZE = inf/).
           with_content(/MAX_UPDATES_PER_SECOND = inf/).
           with_content(/MAX_CREATES_PER_MINUTE = inf/).
           with_content(/LOCAL_DATA_DIR = \/this\/is\/root\/storage\/whisper\//) }
    end
  end

  context "systemd_provider" do
    let(:params) {{ :service_provider => 'systemd' }}

    it { should_not contain_file('/etc/init.d/carbon-aggregator').with_ensure('link').
         with_target('/lib/init/upstart-job') }
    it { should_not contain_file('/etc/init.d/carbon-cache').with_ensure('link').
         with_target('/lib/init/upstart-job') }
    it { should_not contain_file('/etc/init.d/graphite-web').with_ensure('link').
         with_target('/lib/init/upstart-job') }

    context "root_dir" do
      let(:params) {{ :root_dir => '/this/is/root' }}

      describe "carbon-aggregator.service" do
        it { should contain_file('/etc/systemd/system/carbon-aggregator.service').
             with_ensure('present').
             with_content(/User=www-data/).
             with_content(/Group=www-data/).
             with_content(/WorkingDirectory=\/this\/is\/root/).
             with_content(/Environment=GRAPHITE_STORAGE_DIR=\/this\/is\/root\/storage/).
             with_content(/Environment=GRAPHITE_CONF_DIR=\/this\/is\/root\/conf/).
             with_content(/ExecStart=\/this\/is\/root\/bin\/carbon-aggregator.py/).
             with_mode('0444') }
      end

      describe "carbon-cache.service" do
        it { should contain_file('/etc/systemd/system/carbon-cache.service').
             with_ensure('present').
             with_content(/User=www-data/).
             with_content(/Group=www-data/).
             with_content(/WorkingDirectory=\/this\/is\/root/).
             with_content(/Environment=GRAPHITE_STORAGE_DIR=\/this\/is\/root\/storage/).
             with_content(/Environment=GRAPHITE_CONF_DIR=\/this\/is\/root\/conf/).
             with_content(/ExecStart=\/this\/is\/root\/bin\/carbon-cache.py/).
             with_mode('0444') }
      end

      describe "graphite-web.service" do
        it { should contain_file('/etc/systemd/system//graphite-web.service').
             with_ensure('present').
             with_content(/User=www-data/).
             with_content(/Group=www-data/).
             with_content(/WorkingDirectory=\/this\/is\/root/).
             with_content(/Environment=PYTHONPATH=\/this\/is\/root\/lib:\/this\/is\/root\/webapp/).
             with_content(/Environment=GRAPHITE_STORAGE_DIR=\/this\/is\/root\/storage/).
             with_content(/Environment=GRAPHITE_CONF_DIR=\/this\/is\/root\/conf/).
             with_content(/-b127\.0\.0\.1:8000/).
             with_mode('0444') }
      end
    end
  end

  context "carbon_content" do
    let(:params) {{ :root_dir => '/this/is/root', :carbon_content => 'SOMEVAR=SOMECONTENT' }}

    context 'with configured carbon contents' do
      it { should contain_file('/this/is/root/conf/carbon.conf').with_ensure('present').
           with_content(/SOMECONTENT/) }
    end
  end

  describe "aggregation-rules.conf" do
    context 'with unconfigured aggregation rules' do
      it { should contain_file('/opt/graphite/conf/aggregation-rules.conf').
           with_ensure('absent') }
      it { should_not contain_file('/etc/init/carbon-aggregator.conf').
           with_content(/--rules/) }
    end

    context 'with configured aggregation rules' do
      let(:params) { {'aggregation_rules_content' => "Elephants and giraffes!" } }
      it { should contain_file('/opt/graphite/conf/aggregation-rules.conf').
           with_content("Elephants and giraffes!") }
      it { should contain_file('/etc/init/carbon-aggregator.conf').
           with_content(/--rules='\/opt\/graphite\/conf\/aggregation-rules\.conf'/) }
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

  context 'with admin password' do
    let(:params) { {'admin_password' => 'should be a hash' }}
    it { should contain_file('/opt/graphite/webapp/graphite/initial_data.json').with_content(/should be a hash/) }
  end

  it {
    should contain_exec('init-db').with_command('/opt/graphite/bin/python manage.py syncdb --noinput').
    with_cwd('/opt/graphite/webapp/graphite')
  }

  it {
    should contain_file('/opt/graphite/storage/graphite.db').with_owner('www-data')
  }

  it {
    should contain_file('/opt/graphite/storage/log/webapp/').with_owner('www-data')
  }

  it { should contain_file('/opt/graphite/webapp/graphite/local_settings.py') }

  context 'with a templated time zone value' do
    let(:params) { {'time_zone' => 'CHAST' }}
    it { should contain_file('/opt/graphite/webapp/graphite/local_settings.py').
       with_content(/TIME_ZONE = 'CHAST'/)
    }
  end

  context 'with a templated django secret key' do
    context 'no value provided' do
      it { should contain_file('/opt/graphite/webapp/graphite/local_settings.py').
           without_content(/SECRET_KEY/)
      }
    end

    context 'secret key provided' do
      let(:params) { {'django_secret_key' => 'wibble' }}
      it { should contain_file('/opt/graphite/webapp/graphite/local_settings.py').
           with_content(/SECRET_KEY = 'wibble'/)
      }
    end
  end

  context 'with a templated memcache config' do
    context 'no servers' do
      it { should contain_file('/opt/graphite/webapp/graphite/local_settings.py').
           with_content(/MEMCACHE_HOSTS = \[\]/)
      }
    end

    context 'a single server' do
      let(:params) { {'memcache_hosts' => ['127.0.0.1:11211'] }}

      it { should contain_file('/opt/graphite/webapp/graphite/local_settings.py').
           with_content(/MEMCACHE_HOSTS = \["127.0.0.1:11211"\]/)
      }
    end
    context 'multiple servers' do
      let(:params) { {'memcache_hosts' => ['127.0.0.1:11211', '127.0.0.2:11211'] }}

      it { should contain_file('/opt/graphite/webapp/graphite/local_settings.py').
           with_content(/MEMCACHE_HOSTS = \["127.0.0.1:11211", "127.0.0.2:11211"\]/)
      }
    end
  end
end
