# Example of frontend with multiple backends, each with multiple servers.
class { 'haproxy':
  enable => true,
  global_options => {
    'log'           => [ "${::ipaddress_lo} local0", "${::ipaddress_lo} local1 notice" ],
    'chroot'        => '/var/lib/haproxy',
    'pidfile'       => '/var/run/haproxy.pid',
    'maxconn'       => '4000',
    'user'          => 'haproxy',
    'group'         => 'haproxy',
    'daemon'        => '',
    'stats'         => 'socket /var/lib/haproxy/stats level admin',
    'spread-checks' => '2',
  }
  defaults_options => {
    'log'       => 'global',
    'mode'      => 'http',
    'option'    => [ 'httplog', 'dontlognull', 'http-server-close', 'redispatch' ],
    'retries'   => '3',
    'maxconn'   => '4000',
    'timeout'   => [ 'connect 2000', 'queue 2000', 'client 2000', 'server 2000' ],
    'balance'   => 'leastconn',
    'errorfile' => [ '503 /etc/haproxy/503.http' ],
  }
}

# Setup a stats access point. This should not be externally accessible.
haproxy::listen { 'stats':
  ipaddress => '0.0.0.0',
  ports     => '7580',
  options   => {
    'stats' => 'uri /',
  },
}

# Setup two backends - one for web services (ie REST APIs) and one for a
# frontend application.
haproxy::backend { 'webservice-backend':
  options => {
    'description' => 'Backend for REST APIs',
    'option'      => 'httpchk HEAD /healthcheck/ HTTP/1.1\r\n\Host:\ haproxy',
  },
}
haproxy::backend { 'webapp-backend':
  options => {
    'description' => 'Backend for user facing web application',
    'options'     => 'httpchk HEAD /healthcheck/ HTTP/1.1\r\nHost:\ haproxy',
  },
}

# Export the server objects, which could be spread out accross many nodes.
@@haproxy::server { 'webservice1':
  backend_name     => 'webservice-backend',
  server_ipaddress => $::ipaddress_lo,
  port             => '8001',
  options          => {
    'check' => 'inter 5s rise 2 fall 2',
  },
}
@@haproxy::server { 'webservice2':
  backend_name     => 'webservice-backend',
  server_ipaddress => $::ipaddress_lo,
  port             => '8002',
  options          => {
    'check' => 'inter 5s rise 2 fall 2',
  },
}

@@haproxy::server { 'webapp1':
  backend_name     => 'webapp-backend',
  server_ipaddress => $::ipaddress_lo,
  port             => '8101',
  options          => {
    'check' => 'inter 5s rise 2 fall 2',
  },
}
@@haproxy::server { 'webapp2':
  backend_name     => 'webapp-backend',
  server_ipaddress => $::ipaddress_lo,
  port             => '8102',
  options          => {
    'check' => 'inter 5s rise 2 fall 2',
  },
}

# Now configure frontend to use webapp for all requests, except those that are
# prefixed with /rest/. The frontend will override the Server parameter and set
# it to MyApp.
haproxy::frontend { 'example_stack':
  frontend_ipaddress => [ $::ipaddress, $::ipaddress_lo ],
  port               => '80',
  options            => {
    'description' => 'HTTP frontend for example application'
    'rspidel'     => '^Server:.*',
    'rspadd'      => 'Server:\ MyApp',
  },
  backends => {
    'webservice-backend' => 'if { path_beg /rest }',
    'webapp-backend'     => 'if { path_beg / }',
  },
}
