require 'spec_helper'

describe 'graphite', :type => :class do

  describe "start scripts" do
    context "debian upstart" do
      let(:facts) {{ :osfamily => 'Debian' }}
      it { should contain_file('/etc/init.d/carbon-aggregator').with_ensure('link').
           with_target('/lib/init/upstart-job') }
      it { should contain_file('/etc/init.d/carbon-cache').with_ensure('link').
           with_target('/lib/init/upstart-job') }
      it { should contain_file('/etc/init.d/graphite-web').with_ensure('link').
           with_target('/lib/init/upstart-job') }
    end

    context "fedora init" do
      let(:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'Fedora',
        :operatingsystemrelease => '14'
      }}
      it { should contain_file('/etc/init.d/carbon-aggregator') }
      it { should contain_file('/etc/init.d/carbon-cache') }
      it { should contain_file('/etc/init.d/graphite-web') }
    end

    context "fedora systemd" do
      let(:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'Fedora',
        :operatingsystemrelease => '15'
      }}
      it { should contain_file('/lib/systemd/system/carbon-aggregator.service') }
      it { should contain_file('/lib/systemd/system/carbon-cache.service') }
      it { should contain_file('/lib/systemd/system/graphite-web.service') }
    end

    context "redhat init" do
      let(:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '6'
      }}
      it { should contain_file('/etc/init.d/carbon-aggregator') }
      it { should contain_file('/etc/init.d/carbon-cache') }
      it { should contain_file('/etc/init.d/graphite-web') }
    end

    context "redhat systemd" do
      let(:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '7'
      }}
      it { should contain_file('/lib/systemd/system/carbon-aggregator.service') }
      it { should contain_file('/lib/systemd/system/carbon-cache.service') }
      it { should contain_file('/lib/systemd/system/graphite-web.service') }
    end

    context "centos init" do
      let(:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '6'
      }}
      it { should contain_file('/etc/init.d/carbon-aggregator') }
      it { should contain_file('/etc/init.d/carbon-cache') }
      it { should contain_file('/etc/init.d/graphite-web') }
    end

    context "centos systemd" do
      let(:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'Centos',
        :operatingsystemrelease => '7'
      }}
      it { should contain_file('/lib/systemd/system/carbon-aggregator.service') }
      it { should contain_file('/lib/systemd/system/carbon-cache.service') }
      it { should contain_file('/lib/systemd/system/graphite-web.service') }
    end

    context "redhat sysconfig" do
      let(:facts) {{
        :osfamily => 'RedHat',
      }}
      it { should contain_file('/etc/sysconfig/carbon-aggregator') }
      it { should contain_file('/etc/sysconfig/carbon-cache') }
      it { should contain_file('/etc/sysconfig/graphite-web') }
    end

    context "debian upstart contents" do
      let(:facts) {{ :osfamily => 'Debian' }}
      let(:params) {{ :root_dir => '/this/is/root' }}

      describe "carbon-aggregator.conf" do
        it { should contain_file('/etc/init/carbon-aggregator.conf').with_ensure('present').
             with_content(/chdir '\/this\/is\/root'/).
             with_content(/GRAPHITE_STORAGE_DIR='\/this\/is\/root\/storage'/).
             with_content(/GRAPHITE_CONF_DIR='\/this\/is\/root\/conf'/).
             with_content(/exec \/this\/is\/root\/bin\/carbon-aggregator.py/).
             with_mode('0555') }
      end

      describe "carbon-cache.conf" do
        it { should contain_file('/etc/init/carbon-cache.conf').with_ensure('present').
             with_content(/chdir '\/this\/is\/root'/).
             with_content(/GRAPHITE_STORAGE_DIR='\/this\/is\/root\/storage'/).
             with_content(/GRAPHITE_CONF_DIR='\/this\/is\/root\/conf'/).
             with_content(/exec \/this\/is\/root\/bin\/carbon-cache.py/).
             with_mode('0555') }
      end

      describe "graphite-web.conf" do
        it { should contain_file('/etc/init/graphite-web.conf').with_ensure('present').
             with_content(/chdir '\/this\/is\/root\/webapp'/).
             with_content(/PYTHONPATH='\/this\/is\/root\/webapp'/).
             with_content(/GRAPHITE_STORAGE_DIR='\/this\/is\/root\/storage'/).
             with_content(/GRAPHITE_CONF_DIR='\/this\/is\/root\/conf'/).
             with_content(/-b127\.0\.0\.1:8000/).
             with_mode('0555') }
      end
    end

    describe "redhat init contents" do
      let(:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '6'
      }}
      let(:params) {{ :root_dir => '/this/is/root' }}

      describe "carbon-aggregator" do
        it { should contain_file('/etc/init.d/carbon-aggregator').with_ensure('present').
          with_content(/^\. \/etc\/sysconfig\/carbon-aggregator/).
          with_content(/^exec="\/this\/is\/root\/bin\/carbon-aggregator.py/).
          with_mode('0755') }
      end

      describe "carbon-cache" do
        it { should contain_file('/etc/init.d/carbon-cache').with_ensure('present').
          with_content(/^\. \/etc\/sysconfig\/carbon-cache/).
          with_content(/^exec="\/this\/is\/root\/bin\/carbon-cache.py/).
          with_mode('0755') }
      end

      describe "graphite-web" do
        it { should contain_file('/etc/init.d/graphite-web').with_ensure('present').
          with_content(/^\. \/etc\/sysconfig\/graphite-web/).
          with_content(/^DAEMON=\/this\/is\/root\/bin\/gunicorn_django/).
          with_content(/^DAEMON_OPTS=\"-b 127\.0\.0\.1:8000/).
          with_content(/^DAEMON_OPTS=\".*--daemon graphite\/settings.py\"/).
          with_mode('0755') }
      end
    end

    context "redhat systemd contents" do
      let(:facts) {{
        :osfamily => 'RedHat',
        :operatingsystem => 'RedHat',
        :operatingsystemrelease => '7'
      }}
      let(:params) {{ :root_dir => '/this/is/root' }}

      describe "carbon-aggregator.service" do
        it { should contain_file('/lib/systemd/system/carbon-aggregator.service').with_ensure('present').
          with_content(/^EnvironmentFile=\/etc\/sysconfig\/carbon-aggregator/).
          with_content(/^User=root/).
          with_content(/^ExecStart=\/this\/is\/root\/bin\/carbon-aggregator.py/).
          with_mode('0644') }
      end

      describe "carbon-cache.service" do
        it { should contain_file('/lib/systemd/system/carbon-cache.service').with_ensure('present').
          with_content(/^EnvironmentFile=\/etc\/sysconfig\/carbon-cache/).
          with_content(/^User=root/).
          with_content(/^ExecStart=\/this\/is\/root\/bin\/carbon-cache.py/).
          with_mode('0644') }
      end

      describe "graphite-web.service" do
        it { should contain_file('/lib/systemd/system/graphite-web.service').with_ensure('present').
          with_content(/^EnvironmentFile=\/etc\/sysconfig\/graphite-web/).
          with_content(/^User=root/).
          with_content(/^ExecStart=\/this\/is\/root\/bin\/gunicorn_django -b 127\.0\.0\.1:8000 -w2/).
          with_content(/^ExecStart=.* -w2 graphite\/settings.py/).
          with_mode('0644') }
      end
    end

    context "redhat sysconfig contents" do
      let(:facts) {{ :osfamily => 'RedHat' }}
      let(:params) {{ :root_dir => '/this/is/root' }}

      describe "carbon-aggregator" do
        it { should contain_file('/etc/sysconfig/carbon-aggregator').with_ensure('present').
          with_content(/^APP_ROOT="\/this\/is\/root\/webapp\/graphite"$/).
          with_content(/^GRAPHITE_STORAGE_DIR="\/this\/is\/root\/storage"$/).
          with_content(/^GRAPHITE_CONF_DIR="\/this\/is\/root\/conf"$/).
          with_mode('0644') }
      end

      describe "carbon-cache" do
        it { should contain_file('/etc/sysconfig/carbon-cache').with_ensure('present').
          with_content(/^APP_ROOT="\/this\/is\/root\/webapp\/graphite"$/).
          with_content(/^GRAPHITE_STORAGE_DIR="\/this\/is\/root\/storage"$/).
          with_content(/^GRAPHITE_CONF_DIR="\/this\/is\/root\/conf"$/).
          with_mode('0644') }
      end

      describe "graphite-web" do
        it { should contain_file('/etc/sysconfig/graphite-web').with_ensure('present').
          with_content(/^APP_ROOT="\/this\/is\/root\/webapp\/graphite"$/).
          with_content(/^PYTHONPATH="\/this\/is\/root\/webapp"$/).
          with_content(/^GRAPHITE_STORAGE_DIR="\/this\/is\/root\/storage"$/).
          with_content(/^GRAPHITE_CONF_DIR="\/this\/is\/root\/conf"$/).
          with_mode('0644') }
      end
    end
  end

  describe "configuration" do
    let(:params) {{ :root_dir => '/this/is/root' }}
    describe "initial_data.json" do
      context "debian" do
        let(:facts) {{ :osfamily => 'Debian' }}
        it { should contain_file('/this/is/root/webapp/graphite/initial_data.json') }
      end
      context "redhat" do
        let(:facts) {{ :osfamily => 'RedHat' }}
        it { should contain_file('/this/is/root/webapp/graphite/initial_data.json') }
      end
    end

    describe "carbon.conf" do
      context "debian" do
        let(:facts) {{ :osfamily => 'Debian' }}
        it { should contain_file('/this/is/root/conf/carbon.conf').
           with_content(/LOCAL_DATA_DIR = \/this\/is\/root\/storage\/whisper\//) }
      end
      context "redhat" do
        let(:facts) {{ :osfamily => 'RedHat' }}
        it { should contain_file('/this/is/root/conf/carbon.conf').
           with_content(/LOCAL_DATA_DIR = \/this\/is\/root\/storage\/whisper\//) }
      end
    end

    describe "carbon.conf carbon_content" do
      let(:params) {{ :root_dir => '/this/is/root', :carbon_content => 'SOMEVAR=SOMECONTENT' }}
      context "debian" do
        let(:facts) {{ :osfamily => 'Debian' }}
        it { should contain_file('/this/is/root/conf/carbon.conf').with_ensure('present').
          with_content(/SOMECONTENT/) }
      end
      context "redhat" do
        let(:facts) {{ :osfamily => 'RedHat' }}
        it { should contain_file('/this/is/root/conf/carbon.conf').with_ensure('present').
          with_content(/SOMECONTENT/) }
      end
    end

    describe "aggregation-rules.conf" do
      context 'with unconfigured aggregation rules' do
        context "debian" do
          let(:facts) {{ :osfamily => 'Debian' }}
          it { should contain_file('/this/is/root/conf/aggregation-rules.conf').
               with_ensure('absent') }
          it { should_not contain_file('/etc/init/carbon-aggregator.conf').
               with_content(/--rules/) }
        end
        context "redhat" do
          let(:facts) {{ :osfamily => 'RedHat' }}
          it { should contain_file('/this/is/root/conf/aggregation-rules.conf').
               with_ensure('absent') }
          it { should_not contain_file('/etc/init/carbon-aggregator.conf').
               with_content(/--rules/) }
        end
      end
      context 'with configured aggregation rules' do
        let(:params) {{
          :root_dir => '/this/is/root',
          :aggregation_rules_content => "Elephants and giraffes!",
        }}
        context "debian" do
          let(:facts) {{ :osfamily => 'Debian' }}
          it { should contain_file('/this/is/root/conf/aggregation-rules.conf').
               with_content("Elephants and giraffes!") }
          it { should contain_file('/etc/init/carbon-aggregator.conf').
               with_content(/--rules='\/this\/is\/root\/conf\/aggregation-rules\.conf'/) }
        end
        context "redhat" do
          let(:facts) {{ :osfamily => 'RedHat' }}
          it { should contain_file('/this/is/root/conf/aggregation-rules.conf').
               with_content("Elephants and giraffes!") }
          context "init" do
            let(:facts) {{
              :osfamily => 'RedHat',
              :operatingsystem => 'RedHat',
              :operatingsystemrelease => '6'
            }}
            it { should contain_file('/etc/init.d/carbon-aggregator').
                 with_content(/--rules='\/this\/is\/root\/conf\/aggregation-rules\.conf'/) }
          end
          context "systemd" do
            let(:facts) {{
              :osfamily => 'RedHat',
              :operatingsystem => 'RedHat',
              :operatingsystemrelease => '7'
            }}
            it { should contain_file('/lib/systemd/system/carbon-aggregator.service').
                 with_content(/--rules='\/this\/is\/root\/conf\/aggregation-rules\.conf'/) }
          end
        end
      end
    end

    describe "storage-aggregation.conf" do
      context 'with unconfigured storage aggregation' do
        context "debian" do
          let(:facts) {{ :osfamily => 'Debian' }}
          it { should contain_file('/this/is/root/conf/storage-aggregation.conf').
               with_source(/storage-aggregation\.conf/) }
        end
        context "redhat" do
          let(:facts) {{ :osfamily => 'RedHat' }}
          it { should contain_file('/this/is/root/conf/storage-aggregation.conf').
               with_source(/storage-aggregation\.conf/) }
        end
      end
      context 'with configured storage aggregation' do
        let(:params) {{
          :root_dir => '/this/is/root',
          :storage_aggregation_content => "Elephants and giraffes!",
        }}
        context "debian" do
          let(:facts) {{ :osfamily => 'Debian' }}
          it { should contain_file('/this/is/root/conf/storage-aggregation.conf').
               with_content("Elephants and giraffes!") }
        end
        context "redhat" do
          let(:facts) {{ :osfamily => 'RedHat' }}
          it { should contain_file('/this/is/root/conf/storage-aggregation.conf').
               with_content("Elephants and giraffes!") }
        end
      end
    end

    describe "storage-schemas.conf" do
      context 'with unconfigured storage schemas' do
        context "debian" do
          let(:facts) {{ :osfamily => 'Debian' }}
          it { should contain_file('/this/is/root/conf/storage-schemas.conf').
               with_source(/storage-schemas\.conf/) }
        end
        context "redhat" do
          let(:facts) {{ :osfamily => 'RedHat' }}
          it { should contain_file('/this/is/root/conf/storage-schemas.conf').
               with_source(/storage-schemas\.conf/) }
        end
      end
      context 'with configured storage schemas' do
        let(:params) {{
          :root_dir => '/this/is/root',
          :storage_schemas_content => "Elephants and giraffes!",
        }}
        context "debian" do
          let(:facts) {{ :osfamily => 'Debian' }}
          it { should contain_file('/this/is/root/conf/storage-schemas.conf').
               with_content("Elephants and giraffes!") }
        end
        context "redhat" do
          let(:facts) {{ :osfamily => 'RedHat' }}
          it { should contain_file('/this/is/root/conf/storage-schemas.conf').
               with_content("Elephants and giraffes!") }
        end
      end
    end

    describe "initial_data.json" do
      describe "admin password" do
        let(:params) {{
          :root_dir => '/this/is/root',
          :admin_password => "should be a hash",
        }}
        # let(:params) { {'admin_password' => 'should be a hash' }}
        context "debian" do
          let(:facts) {{ :osfamily => 'Debian' }}
          it { should contain_file('/this/is/root/webapp/graphite/initial_data.json').
               with_content(/should be a hash/) }
        end
        context "redhat" do
          let(:facts) {{ :osfamily => 'RedHat' }}
          it { should contain_file('/this/is/root/webapp/graphite/initial_data.json').
               with_content(/should be a hash/) }
        end
      end
    end

    describe "local_settings.py" do
      context "debian" do
        let(:facts) {{ :osfamily => 'Debian' }}
        it { should contain_file('/this/is/root/webapp/graphite/local_settings.py').
             with_source('puppet:///modules/graphite/local_settings.py') }
      end
      context "redhat" do
        let(:facts) {{ :osfamily => 'RedHat' }}
        it { should contain_file('/this/is/root/webapp/graphite/local_settings.py').
             with_source('puppet:///modules/graphite/local_settings.py') }
      end
    end

  end

  describe "files" do
    let(:params) {{ :root_dir => '/this/is/root' }}

    describe "init-db" do
      context "debian" do
        let(:facts) {{ :osfamily => 'Debian' }}
        it { should contain_exec('init-db').
             with_command('/this/is/root/bin/python manage.py syncdb --noinput').
             with_cwd('/this/is/root/webapp/graphite') }
      end
      context "redhat" do
        let(:facts) {{ :osfamily => 'RedHat' }}
        it { should contain_file('/this/is/root/webapp/graphite/local_settings.py').
            with_source('puppet:///modules/graphite/local_settings.py') }
      end
    end

    describe "storage" do
      context "debian" do
        let(:facts) {{ :osfamily => 'Debian' }}
        it { should contain_file('/this/is/root/storage').with_owner('www-data').
             with_mode('0775') }
        it { should contain_file('/this/is/root/storage/whisper').
             with_owner('www-data').with_mode('0775') }
      end
      context "redhat" do
        let(:facts) {{ :osfamily => 'RedHat' }}
        it { should contain_file('/this/is/root/storage').with_owner('root').
             with_mode('0775') }
        it { should contain_file('/this/is/root/storage/whisper').
             with_owner('root').with_mode('0775') }
      end
    end

    describe "graphite-db" do
      context "debian" do
        let(:facts) {{ :osfamily => 'Debian' }}
        it { should contain_file('/this/is/root/storage/graphite.db').with_owner('www-data') }
      end
      context "redhat" do
        let(:facts) {{ :osfamily => 'RedHat' }}
        it { should contain_file('/this/is/root/storage/graphite.db').with_owner('root') }
      end
    end

    describe "logs" do
      context "debian" do
        let(:facts) {{ :osfamily => 'Debian' }}
        it { should contain_file('/this/is/root/storage/log/webapp/').with_owner('www-data') }
      end
      context "redhat" do
        let(:facts) {{ :osfamily => 'RedHat' }}
        it { should contain_file('/this/is/root/storage/log/webapp/').with_owner('root') }
      end
    end
  end

end
