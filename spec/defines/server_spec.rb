require 'spec_helper'

describe 'haproxy::server' do
  let(:title) { 'greek' }
  let(:facts) {{ :ipaddress => '1.1.1.1' }}

  context "when default parameters are provided" do
    let(:params) do
      {
        :name         => 'alpha-server',
        :backend_name => 'alpha-backend'
      }
    end

    it do
      should contain_concat__fragment('alpha-server_server_block').with(
        :order => '30-alpha-backend_server_alpha-server',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "   server alpha-server 1.1.1.1:80   check  inter 2s rise 2 fall 2\n")
    end
  end
  context "when ipaddress and port are provided" do
    let(:params) do
      {
        :name             => 'beta-server',
        :backend_name     => 'beta-backend',
        :server_ipaddress => '42.42.42.42',
        :port             => '4200'
      }
    end

    it do
      should contain_concat__fragment('beta-server_server_block').with(
        :order => '30-beta-backend_server_beta-server',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "   server beta-server 42.42.42.42:4200   check  inter 2s rise 2 fall 2\n")
    end
  end
  context "when empty option array is provided" do
    let(:params) do
      {
        :name         => 'gamma-server',
        :backend_name => 'gamma-backend',
        :options      => {}
      }
    end

    it do
      should contain_concat__fragment('gamma-server_server_block').with(
        :order => '30-gamma-backend_server_gamma-server',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "   server gamma-server 1.1.1.1:80 \n")
    end
  end
  context "when many options are provided" do
    let(:params) do
      {
        :name         => 'delta-server',
        :backend_name => 'delta-backend',
        :options      => {
          'maxconn' => '5',
          'check' => 'inter 5s rise 10 fall 5',
          'weight' => '100'
        }
      }
    end

    it do
      should contain_concat__fragment('delta-server_server_block').with(
        :order => '30-delta-backend_server_delta-server',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "   server delta-server 1.1.1.1:80   check  inter 5s rise 10 fall 5  maxconn  5  weight  100\n")
    end
  end
end
