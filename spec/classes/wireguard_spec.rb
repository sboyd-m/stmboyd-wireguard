# frozen_string_literal: true

require 'spec_helper'

describe 'wireguard' do
  include_context 'hieradata'
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:node) { 'supernode.example.com' }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_class('wireguard::configure') }
      it { is_expected.to contain_class('wireguard::install') }
      it { is_expected.to contain_package('wireguard') }
      it { is_expected.to contain_concat('/etc/wireguard/wg0.conf') }

      it { is_expected.to contain_service('wg-quick@wg0.service').with(
        ensure: 'running',
        enable: true
      )}

      it { is_expected.to contain_concat__fragment('Interface definition').with(
        content: <<~EOF
          [Interface]
          Table = 2
          Address = 10.0.1.1/24, fdc9:281f:4d7:9ee9::1:1/64
          ListenPort = 51820
          PrivateKey = wireguard
        EOF
        )}

      context "with export_default_route set to false" do
        subject { exported_resources }

        it { is_expected.to contain_concat__fragment('Peer supernode').with(
          target: '/etc/wireguard/wg0.conf',
          tag: '["coolkids", "supernode"]',
          content: <<~EOT

            [Peer]
            PublicKey = public
            AllowedIPs = 10.0.1.1/32, fdc9:281f:4d7:9ee9::1:1/128
            Endpoint = 172.16.254.254:51820
            PersistentKeepalive = 25
          EOT
        )}
      end

      context "with export_default_route set to true" do
        let(:params) {{
          export_default_route: true,
        }}

        subject { exported_resources }

        it { is_expected.to contain_concat__fragment('Peer supernode').with(
          content: <<~EOT

            [Peer]
            PublicKey = public
            AllowedIPs = 0.0.0.0/0, ::/0
            Endpoint = 172.16.254.254:51820
            PersistentKeepalive = 25
          EOT
        )}
      end
    end
  end
end
