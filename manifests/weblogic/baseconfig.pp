class profile::weblogic::baseconfig(
  $enable_gui_admin = $::profile::weblogic::params::enable_gui_admin
) inherits ::weblogic::params {

  validate_bool($enable_gui_admin)

  require ::orawls::urandomfix

  class { '::firewall': ensure => 'stopped', }

  if $enable_gui_admin {
    require ::epel
  
    Exec { path => ['/bin','/sbin','/usr/bin','/usr/sbin','/usr/local/bin'], logoutput => true, }

    exec { 'enable GUI admin tools':
      command => "yum -y groupinstall 'Xfce'",
      unless => 'rpm -qa | grep -i xfce',
      timeout => 0,
    }

    package { [ 'firefox', 'x2goserver', 'x2goserver-xsession' ]: ensure => installed, } ->
    package { 'NetworkManager-gnome': ensure => absent, } ->
    package { 'NetworkManager': ensure => absent, } ~>
    reboot { 'reset network after NetworkManager purge': }
  }

}
