class wireguard::configure () {
  concat { '/etc/wireguard/wg0.conf':
    ensure         => present,
    owner          => root,
    group          => root,
    mode           => '0400',
    show_diff      => false,
    ensure_newline => true,
  }

  concat::fragment { 'Interface definition':
    target  => '/etc/wireguard/wg0.conf',
    content => epp('wireguard/if.epp', {
        local_addr4 => $wireguard::local_addr4,
        local_addr6 => $wireguard::local_addr6,
        private_key => $wireguard::private_key,
    }),
  }

  $exportable_ip4 = regsubst($wireguard::local_addr4, '\\d{1,2}$', '32')
  $exportable_ip6 = regsubst($wireguard::local_addr6, '\\d{1,3}$', '128')

  # Export this interface into the common mesh group
  @@concat::fragment { "Peer ${$facts['networking']['hostname']}":
    target  => '/etc/wireguard/wg0.conf',
    tag     => $wireguard::mesh_key,
    content => epp('wireguard/peer_fragment.epp', {
        public_key      => $wireguard::public_key,
        public_endpoint => $facts['networking']['ip'],
        peer_addr4      => $exportable_ip4,
        peer_addr6      => $exportable_ip6,
    }),
  }

  # Collect our peers
  Concat::Fragment <<| tag == $wireguard::mesh_key |>>
}
