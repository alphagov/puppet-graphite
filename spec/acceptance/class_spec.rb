require 'spec_helper_acceptance'

describe 'graphite' do
  it 'should run successfully' do
    pp = <<-END
      class { 'python':
        pip        => true,
        dev        => true,
        virtualenv => true,
      }

      class { 'graphite':
        require => Class['python'],
      }
    END

    # Apply twice to ensure no errors the second time.
    apply_manifest(pp, :catch_failures => true) do |r|
      expect(r.stderr).not_to match(/error/i)
    end
    apply_manifest(pp, :catch_failures => true) do |r|
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
end
