class profile::weblogic::staging inherits ::profile::weblogic::params {

  $source = $::profile::weblogic::source
  validate_re($source, '^.+$')
  
  require ::staging
  require ::epel

  staging::file { 'weblogic-installer.jar':
    source => $source,
    timeout => '3000',
  }

}
