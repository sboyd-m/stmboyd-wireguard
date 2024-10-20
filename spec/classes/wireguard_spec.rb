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
    end
  end
end
