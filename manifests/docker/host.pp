class profile::docker::host(
  $users = [],
  $runs = $::profile::docker::params::default_runs,
  $images = $::profile::docker::params::default_images,
  $port = $::profile::docker::params::default_host_port,
  $firewall_chain = $::profile::docker::params::default_firewall_chain
) inherits ::profile::docker::params {

  validate_array($users)
  validate_hash($images, $runs)
  
  unless is_integer($port) { fail("Failed validating '$port' parameter!") }

  validate_re($firewall_chain, '^.+$')

  $_address = gethostbyname($::hostname)
  $address = $_address['address']
  unless is_ip_address($address) { fail("Could not compute IP address!") }

 
  class { '::docker': tcp_bind => "tcp://${address}:${port}", }

  $images_defaults = { 'ensure' => 'latest' }
  create_resources('::docker::image', $images, $images_defaults)

  $runs_defaults = {}
  create_resources('::docker::run', $runs, $runs_defaults)


  require ::profile::consul::agent

  ::consul::service { 'docker host consul service':
    port => $port,
    address => $address,
    checks => [{
      interval => '10s',
      http => "http://${address}:${port}/_ping"
    }],
    tags => [ $::environment, $module_name, $caller_module_name ],
  }


  firewall { "000 - forward to ${firewall_chain} chain":
    chain => 'INPUT',
    jump => $firewall_chain,
  } ->

  firewallchain { $firewall_chain:
    ensure => present,
    name => "${firewall_chain}:filter:IPv4",
    purge => true,
  } ->

  firewall { "0 - tcp/${port}":
    ensure => present,
    chain => $firewall_chain,
    port => $port,
    proto => 'tcp',
    action => 'accept',
    require => Firewallchain[$firewall_chain],
  }

}
