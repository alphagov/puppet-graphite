require 'spec_helper'

describe 'graphite', :type => :class do
  it { should contain_service('carbon-cache') }
  it { should contain_service('graphite-web') }
end
