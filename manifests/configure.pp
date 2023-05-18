class wireguard::configure () {
  file { '/etc/wireguard/wg0.conf':
    ensure    => file,
    content   => epp('wireguard/if.epp', {
        local_addr4 => $wireguard::local_addr4,
        local_addr6 => $wireguard::local_addr6,
        private_key => $wireguard::private_key,
    }),
    owner     => root,
    group     => root,
    mode      => '0400',
    show_diff => false,
  }
}
