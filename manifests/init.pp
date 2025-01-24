class wireguard (
  Stdlib::IP::Address::V4::CIDR $local_addr4,
  Stdlib::IP::Address::V6::CIDR $local_addr6,
  String $package_name,
  String $service,
  String $private_key,
  String $public_key,
  String $mesh_key,
  Optional[Variant[Integer, Enum['off']]] $table = undef,
  Boolean $export_default_route = false,
) {
  class { 'wireguard::install': }
  -> class { 'wireguard::configure': }
  ~> service { "${wireguard::service}@wg0.service":
    ensure => running,
    enable => true,
  }
}
