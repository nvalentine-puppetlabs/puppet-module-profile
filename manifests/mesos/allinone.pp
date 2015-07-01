class profile::mesos::allinone (

) inherits ::profile::mesos::params {

  require ::profile::mesos
  require ::profile::consul::agent

  class { '::zookeeper': repo => 'cloudera', } ->
  class { '::mesos': repo => 'mesosphere', } ~>
  class { '::mesos::master': }

  $_address = gethostbyname($::hostname)
  $address = $_address['address']
  unless is_ip_address($address) { fail("Could not compute IP address!") }

  Consul::Service {
    address => $address,
    tags => [ $::environment, $module_name, $caller_module_name ],
  }

  # not sure these will work; also may need to install and monitor marathon etc

  ::consul::service { 'mesos master consul service':
    port => '5050',
    checks => [{
      interval => '10s',
      http => 'http://$address}:5050'
    }],
  }

  ::consul::service { 'mesos slave consul service':
    port => '5051',
     checks => [{
      interval => '10s',
      http => 'http://$address}:5050'
    }],
  }
 
}
