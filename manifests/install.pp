class wireguard::install () {
  ensure_packages([$wireguard::package_name])
}
