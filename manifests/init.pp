class wireguard (
  Stdlib::IP::Address::V4::CIDR $local_addr4,
  Stdlib::IP::Address::V6::CIDR $local_addr6,
  String $package_name,
  String $service,
  String $private_key,
  String $public_key,
  String $mesh_key,
  Optional[Variant[Integer, Enum['off']]] $table = undef,
  Stdlib::IP::Address::V6::CIDR $nat_source6 = $local_addr6,
  Stdlib::IP::Address::V4::CIDR $nat_source4 = $local_addr4,
) {
  class { 'wireguard::install': }
  -> class { 'wireguard::configure': }
  ~> service { "${wireguard::service}@wg0.service":
    ensure => running,
  }
}
