# == Define: haproxy::backend
#
# FIXME
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
    order   => "30-${name}-00",
    target  => '/etc/haproxy/haproxy.cfg',
    content => template('haproxy/haproxy_backend_block.erb'),
  }
  if $collect_exported {
    Haproxy::Server <<| backend_name == $name |>>
  }
}
