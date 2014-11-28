require 'spec_helper'

describe 'graphite', :type => :class do

  let(:params) {{
    :user => 'graphite',
    :group => 'graphite',
    :manage_user => true,
  }}
  
  it { should contain_user('carbon_cache_user').with_ensure('present').
       with_name('graphite').
       with_gid('graphite')
  }
  it { should contain_group('carbon_cache_group').with_ensure('present').
       with_name('graphite')
  }

end
