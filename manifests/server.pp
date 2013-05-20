# == Define: haproxy::server
#
# FIXME
#
# === Requirements
#
# ripienaar/concat module
#
# === Paramateres
#
# [*name*]
#   The name of the defined server. This name goes right after the 'server'
#   statement in the backend block of the haproxy.cfg
#
# [*backend_name*]
#   The haproxy backend's instance name (or, the title of the haproxy::backend
#   resource). This must match up with the declared haproxy::backend resource.
#
# [*server_ipaddress*]
#   The ip address used to contact this server.
#
# [*port*]
#   Port this server will accept connections from.
#
# [*options*]
#   Hash of options to be specified at the end of the server line.
#
# === Examples
#
#   haproxy::server { 'webservicehost-process':
#     server_ipaddress => $::ipaddress,
#     port             => '8001',
#     options          => {
#       'maxconn' => '4',
#       'check'   => 'inter 2s rise 2 fall 2',
#     }
#   }
#
define haproxy::server (
  $backend_name,
  $server_ipaddress = $::ipaddress,
  $port             = '80',
  $options          = {
    'check' => 'inter 2s rise 2 fall 2',
  },
) {
  concat::fragment { "${name}_server_block":
    order   => "30-${backend_name}_server_${name}",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_server_block.erb'),
  }
}
