class profile::consul::params  {

  unless 'linux' == $::kernel {
    fail("Sorry, ${::kernel} not supported by this class at this time.")
  }

  $default_bootstrap_expect = 1
  $default_server = 'master'
  $default_datacenter = 'demo'
  $default_data_dir = $::kernel ? {
    'windows' => 'C:\consul',
    default => '/var/consul'
  }
 
  $_bind_addr = gethostbyname($::hostname)
  $bind_addr = $_bind_addr['address']
  unless is_ip_address($bind_addr) { fail("Cannot compute the bind_addr for consul!") }
  
  $default_bind_addr = $::virtual ? {
    'virtualbox' => $bind_addr,
    default => '0.0.0.0'
  }

  $default_firewall_chain = 'consulio'

  $default_server_firewall_tcp_ports = {
    '0 - tcp/8300' => { port => '8300' },
    '1 - tcp/8301' => { port => '8300' },
    '2 - tcp/8302' => { port => '8302' },
    '3 - tcp/8500' => { port => '8500' },
    '4 - tcp/8600' => { port => '8600' }
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
