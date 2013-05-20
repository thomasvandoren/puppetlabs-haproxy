require 'spec_helper'

describe 'haproxy::backend' do
  let(:title) { 'more-greek' }

  context "when default parameters are provided" do
    let(:params) do
      {
        :name => 'zeta-backend'
      }
    end

    it do
      should contain_concat__fragment('zeta-backend_backend_block').with(
        :order => '30-zeta-backend_',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nbackend zeta-backend\n   description  description goes here\n")
    end
  end
  context "when description is provided" do
    let(:params) do
      {
        :name => 'chi-backend',
        :options => {
          'description' => 'backend for chi server group'
        }
      }
    end

    it do
      should contain_concat__fragment('chi-backend_backend_block').with(
        :order => '30-chi-backend_',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nbackend chi-backend\n   description  backend for chi server group\n")
    end
  end
  context "when many options are provided" do
    let(:params) do
      {
        :name => 'tau-backend',
        :options => {
          'description' => "backend for tau server group",
          'stats' => ["enable",
                      "uri /admin?stats"],
          'option' => ["httpchk HEAD /healthcheck/ HTTP/1.1\\r\\nHost:\\ haproxy",
                       "forwardfor header X-Client"],
        }
      }
    end

    it do
      should contain_concat__fragment('tau-backend_backend_block').with(
        :order => '30-tau-backend_',
        :target => '/etc/haproxy/haproxy.cfg',
        :content => "\nbackend tau-backend\n   description  backend for tau server group\n   option  httpchk HEAD /healthcheck/ HTTP/1.1\\r\\nHost:\\ haproxy\n   option  forwardfor header X-Client\n   stats  enable\n   stats  uri /admin?stats\n")
    end
  end
end
