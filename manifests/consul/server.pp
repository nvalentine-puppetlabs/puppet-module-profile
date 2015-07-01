class profile::consul::server(
  $bootstrap_expect = $::profile::consul::params::default_bootstrap_expect,
  $datacenter = $::profile::consul::params::default_datacenter,
  $firewall_chain = $::profile::consul::params::default_firewall_chain,
  $firewall_udp = $::profile::consul::params::default_server_firewall_udp_ports,
  $firewall_tcp = $::profile::consul::params::default_server_firewall_tcp_ports,
  $data_dir = $::profile::consul::params::default_data_dir,
  $bind_addr = $::profile::consul::params::default_bind_addr
) inherits ::profile::consul::params {

  validate_re($bootstrap_expect, '^\d+$')
  multi_validate_re($datacenter, $firewall_chain, $bind_addr, '^.+$')
  validate_hash($firewall_udp, $firewall_tcp)
  validate_absolute_path($data_dir)

  require ::profile::consul

  class { '::consul':
    config_hash => {
      'bootstrap_expect' => $bootstrap_expect,
      'client_addr' => '0.0.0.0',
      'bind_addr' => $bind_addr,
      'datacenter' => $datacenter,
      'node_name' => $::hostname,
      'data_dir' => $data_dir,
      'log_level' => 'INFO',
      'server' => true,
      'ui_dir' => '/var/consul/ui',
    },
  }

  firewall { "000 forward to ${firewall_chain} chain":
    chain => 'INPUT',
    jump => $firewall_chain,
  }

  firewallchain { $firewall_chain:
    ensure => present,
    name => "${firewall_chain}:filter:IPv4",
    purge => true,
  }

  $firewall_defaults = {
    'ensure' => 'present',
    'chain' => $firewall_chain,
    'require' => Firewallchain[$firewall_chain],
    'action' => 'accept'
  }

  $firewall_tcp_defaults = merge($firewall_defaults, { 'proto' => 'tcp' })
  create_resources('firewall', $firewall_tcp, $firewall_tcp_defaults)

  $firewall_udp_defaults = merge($firewall_defaults, { 'proto' => 'udp' })
  create_resources('firewall', $firewall_udp, $firewall_udp_defaults)
  
}
