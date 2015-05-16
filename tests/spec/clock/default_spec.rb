#Spec for default test playbook
require 'spec_helper'

describe package('ntp') do
  it { should be_installed }
end

describe service('ntpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('ntp'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/timezone'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  its(:content) { should include 'Europe/Rome' }
end

describe file('/etc/sysconfig/clock'), :if => os[:family] == 'redhat' && os[:release] == 6 do
  its(:content) { should include 'Europe/Rome' }
end

describe port(123) do
  it { should be_listening.with('udp') }
end
