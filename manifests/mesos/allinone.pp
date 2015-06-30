class profile::mesos::allinone (

) inherits ::profile::mesos::params {

  require ::profile::mesos

  class { '::zookeeper': repo => 'cloudera', } ->
  class { '::mesos': repo => 'mesosphere', } ~>
  class { '::mesos::master': }
  
}
