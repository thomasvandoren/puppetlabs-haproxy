# == Define: haproxy::frontend
#
# Setup a frontend configuration block. Each frontend needs one or more backend
# members. The backends should be declared on the same node as the frontend.
#
# === Requirements
#
# ripienaar/concat module
#
# === Paramaters
#
# [*name*]
#   The name of the defined fronted type. This name goes right after the
#   'frontend' statement in the haproxy.cfg.
#
# [*frontend_ipaddress*]
#   The ipaddress to bind to for this frontend. This can either be a
#   single address or an array of addresses.
#
# [*port*]
#   The port to accept connection for this frontend.
#
# [*options*]
#   Hash of other options to add to the frontend.
#
# [*backends*]
#   Array of two element arrays. Each two element array has the backend name in
#   the first element and the path qualifier in the second element. An ordered
#   hash would be easier to work with here, but ruby 1.8 does not preserve
#   insertion order :-(
#
# === Examples
#
#   haproxy::frontend { 'my_stack':
#     frontend_ipaddress => $::ipaddress,
#     port               => '80',
#     options            => {
#       'description' => 'HTTP Frontend for my stack',
#       'rspidel'     => '^Server:.*',
#       'rspadd'      => 'Server:\ MyApp',
#     },
#     backends           => [
#       ['payment-backend',    'if { path_beg /payment }'],
#       ['webservice-backend', 'if { path_beg /rest }']
#     ],
#   }
#
define haproxy::frontend (
  $frontend_ipaddress = $::ipaddress,
  $port               = '80',
  $options            = {
    'description' => 'frontend description goes here',
  },

  $backends           = [],
) {
  concat::fragment { "${name}_frontend":
    order   => "40-${name}",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_frontend_block.erb'),
  }
}
