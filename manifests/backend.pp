# == Define: haproxy::backend
#
# Setup a backend configuration block. Each backend needs one or more server
# members. The haproxy::server resources can be defined and exported on other
# nodes and then collected with haproxy::backend. The haproxy::backend and
# haproxy::frontend resources need to be declared on the same node to end up in
# the correct haproxy configuration.
#
# === Requirements
#
# ripienaar/concat module
#
# === Parameters
#
# [*name*]
#   The name of the defined backend type. This name goes right after the
#   'backend' statement in the haproxy.cfg.
#
# [*collect_exported*]
#   Collect exported Haproxy::Server resources.
#
# [*options*]
#   Hash of other options to add to backend.
#
# === Examples
#
#   haproxy::backend { 'webservice-backend':
#     options => {
#       'description' => 'Backend for web services',
#       'option'      => 'httpchk HEAD /healthcheck/ HTTP/1.1\r\nHost:\ haproxy',
#     },
#   }
#
define haproxy::backend (
  $collect_exported = true,
  $options = {
    'description' => 'description goes here',
  },
) {
  concat::fragment { "${name}_backend_block":
    order   => "30-${name}_",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_backend_block.erb'),
  }
  if $collect_exported {
    Haproxy::Server <<| backend_name == $name |>>
  }
}
