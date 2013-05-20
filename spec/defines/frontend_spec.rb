require 'spec_helper'

describe 'haproxy::frontend' do
  let(:title) { 'and-more-greek' }
  let(:facts) {{ :ipaddress => '1.1.1.1' }}

  context "when default parameters are provided" do
    let(:params) do
      {
        :name => 'eta-frontend'
      }
    end

    it do
      should contain_concat__fragment('eta-frontend_frontend').with(
        :order => '40-eta-frontend',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nfrontend eta-frontend\n   bind 1.1.1.1:80\n   description  frontend description goes here\n")
    end
  end
  context "when ipaddress and port are provided" do
    let(:params) do
      {
        :name => 'theta-frontend',
        :frontend_ipaddress => '17.17.17.17',
        :port => '1700'
      }
    end

    it do
      should contain_concat__fragment('theta-frontend_frontend').with(
        :order => '40-theta-frontend',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nfrontend theta-frontend\n   bind 17.17.17.17:1700\n   description  frontend description goes here\n")
    end
  end
  context "when multiple ipaddresses are provided" do
    let(:params) do
      {
        :name => 'iota-frontend',
        :frontend_ipaddress => ['10.0.0.1', '10.0.0.2', '10.0.0.3'],
        :port => '8000'
      }
    end

    it do
      should contain_concat__fragment('iota-frontend_frontend').with(
        :order => '40-iota-frontend',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nfrontend iota-frontend\n   bind 10.0.0.1:8000\n   bind 10.0.0.2:8000\n   bind 10.0.0.3:8000\n   description  frontend description goes here\n")
    end
  end
  context "when description is provided" do
    let(:params) do
      {
        :name => 'kappa-frontend',
        :options => {
          'description' => 'frontend for kappa service cluster'
        }
      }
    end

    it do
      should contain_concat__fragment('kappa-frontend_frontend').with(
        :order => '40-kappa-frontend',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nfrontend kappa-frontend\n   bind 1.1.1.1:80\n   description  frontend for kappa service cluster\n")
    end
  end
  context "when many options are provided" do
    let(:params) do
      {
        :name => 'lambda-frontend',
        :options => {
          'description' => 'lambda cluster',
          'option' => 'forwardfor',
          'maxconn' => '500'
        }
      }
    end

    it do
      should contain_concat__fragment('lambda-frontend_frontend').with(
        :order => '40-lambda-frontend',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nfrontend lambda-frontend\n   bind 1.1.1.1:80\n   description  lambda cluster\n   maxconn  500\n   option  forwardfor\n")
    end
  end
  context "when a backend is provided" do
    let(:params) do
      {
        :name => 'mu-frontend',
        :backends => { 'webservices' => 'if { path_beg / }' }
      }
    end

    it do
      should contain_concat__fragment('mu-frontend_frontend').with(
        :order => '40-mu-frontend',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nfrontend mu-frontend\n   bind 1.1.1.1:80\n   description  frontend description goes here\n   use_backend  webservices  if { path_beg / }\n")
    end
  end
  context "when multiple backend servers are provided" do
    let(:params) do
      {
        :name => 'pi-frontend',
        :backends => {
          'webservices' => 'if { path_beg /rest }',
          'payments' => 'if { path_beg /payments }'
        }
      }
    end

    it do
      should contain_concat__fragment('pi-frontend_frontend').with(
        :order => '40-pi-frontend',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nfrontend pi-frontend\n   bind 1.1.1.1:80\n   description  frontend description goes here\n   use_backend  webservices  if { path_beg /rest }\n   use_backend  payments  if { path_beg /payments }\n")
    end
  end
  context "when multiple ipaddresses, options, and backends are provided" do
    let(:params) do
      {
        :name => 'rho-frontend',
        :frontend_ipaddress => ['192.168.1.1', '192.168.2.1', '192.168.3.1'],
        :options => {
          'description' => 'rho cluster',
          'compression' => ['algo gzip deflate',
                            'type application/json text/css text/html'],
          'rspidel' => "Server:.*",
          'rspadd' => "Server:\\ MyApp",
        },
        :backends => {
          'app' => 'if { path_beg /app }',
          'api' => 'if { path_beg /rest }',
          'web' => 'if { path_beg / }'
        }
      }
    end

    it do
      should contain_concat__fragment('rho-frontend_frontend').with(
        :order => '40-rho-frontend',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nfrontend rho-frontend\n   bind 192.168.1.1:80\n   bind 192.168.2.1:80\n   bind 192.168.3.1:80\n   compression  algo gzip deflate\n   compression  type application/json text/css text/html\n   description  rho cluster\n   rspadd  Server:\\ MyApp\n   rspidel  Server:.*\n   use_backend  app  if { path_beg /app }\n   use_backend  api  if { path_beg /rest }\n   use_backend  web  if { path_beg / }\n")
    end
  end
end
