require 'spec_helper_acceptance'

shared_examples_for "working graphite" do |puppet_manifest|
  it 'should run successfully' do
    # Apply twice to ensure no errors the second time.
    apply_manifest(puppet_manifest, :catch_failures => true) do |r|
      expect(r.stderr).not_to match(/error/i)
    end
    apply_manifest(puppet_manifest, :catch_failures => true) do |r|
      expect(r.stderr).not_to match(/error/i)

      # ensure idempotency
      expect(r.exit_code).to be_zero
    end
  end

  describe service('carbon-aggregator') do
    it { should_not be_running }
  end

  describe service('carbon-cache') do
    it { should be_running }
    it 'should open port 2003' do
      expect(hosts.first.port_open?(2003)).to be_truthy
    end
  end

  describe service('graphite-web') do
    it { should be_running }
    it 'should serve dashboard without errors' do
      shell('curl -fsS http://localhost:8000/dashboard/')
    end
  end

  describe 'carbon and graphite-web' do
    it 'should work end-to-end' do
      run_script_on(hosts.first, File.expand_path('../graphite_integration.rb', __FILE__))
    end
  end
end

describe 'graphite' do
  context 'default params' do
    it_should_behave_like "working graphite", <<-END
      class { 'python':
        pip        => true,
        dev        => true,
        virtualenv => true,
      }

      class { 'graphite':
        require => Class['python'],
      }
    END
  end

  context 'custom root_dir' do
    it_should_behave_like "working graphite", <<-END
      class { 'python':
        pip        => true,
        dev        => true,
        virtualenv => true,
      }

      class { 'graphite':
        root_dir => '/usr/local/graphite',
        require  => Class['python'],
      }
    END
  end
end
