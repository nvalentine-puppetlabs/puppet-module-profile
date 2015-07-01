class profile::consul::params  {

  $default_bootstrap_expect = 1
  $default_server = 'master'
  $default_datacenter = 'demo'
  $default_data_dir = $::kernel ? {
    'windows' => 'C:\consul',
    default => '/var/consul'
  }
  $default_bind_addr = $::ipaddress

  $default_firewall_chain = 'consulio'

  $default_server_firewall_tcp_ports = {
    '0 - tcp/8300' => { port => '8300' },
    '1 - tcp/8302' => { port => '8302' },
    '2 - tcp/8500' => { port => '8500' },
    '3 - tcp/8600' => { port => '8600' }
  }

  $default_server_firewall_udp_ports = {
    '0 - udp/8301' => { port => '8301' },
    '1 - udp/8600' => { port => '8600' },
  }

  $default_agent_firewall_tcp_ports = {
    '0 - tcp/8301' => { port => '8301' },
    '1 - tcp/8400' => { port => '8400' },
  }

  $default_agent_firewall_udp_ports = {
    '0 - udp/8301' => { port => '8301' },
  }

}
