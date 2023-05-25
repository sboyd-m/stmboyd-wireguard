# frozen_string_literal: true

require 'spec_helper'

describe 'wireguard' do
  include_context 'hieradata'
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_file('/etc/wireguard/wg0.conf').with(
        'content' => '[Interface]
Address = 10.0.1.1/24, fdc9:281f:4d7:9ee9::1:1/64
ListenPort = 51820
PrivateKey = wireguard

[Peer]
PublicKey = wireguard
AllowedIPS = 10.0.1.2/32
Endpoint = 1.1.1.1:51820

[Peer]
PublicKey = bobguard
AllowedIPS = 10.0.1.3/32
')}
    end
  end
end
