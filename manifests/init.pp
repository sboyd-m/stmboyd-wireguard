class wireguard (
  Stdlib::IP::Address::V4::CIDR $local_addr4,
  Stdlib::IP::Address::V6::CIDR $local_addr6,
  String $package_name,
  String $private_key,
  Boolean $is_vpn_server = false,
) {
  class { 'wireguard::install': }
  -> class { 'wireguard::configure': }
}
