# == Define: haproxy::frontend
#
# FIXME
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
#   Hash of backend names to path qualifiers.
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
#     backends           => {
#       'payment-backend' => 'if { path_beg /payment }',
#       'webservice-backend' => 'if { path_beg /rest }',
#     },
#   }
#
define haproxy::frontend (
  $frontend_ipaddress = $::ipaddress,
  $port               = '80',
  $options            = {
    'description' => 'frontend description goes here',
  },

  # FIXME: This works for ruby 1.9+, because hashes preserve insertion
  #        order. However, for ruby 1.8 the insertion order is not
  #        preserved. $backends should be implemented as an array of tuples so
  #        1.8+ is supported. (thomasvandoren, 2013-05-21)
  $backends           = {
  },
) {
  concat::fragment { "${name}_frontend":
    order   => "40-${name}",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_frontend_block.erb'),
  }
}
