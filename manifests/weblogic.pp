class profile::weblogic(
  $source,
  $wls_user = $::profile::weblogic::params::default_wls_user,
  $wls_group = $::profile::weblogic::params::default_wls_group
) inherits ::profile::weblogic::params {

  multi_validate_re($source, $wls_user, $wls_group, '^.+$')

  class { '::profile::weblogic::staging': } ->
  class { '::profile::weblogic::install': } ->
  class { '::profile::weblogic::config': } ~>
  class { '::profile::weblogic::service': } ->
  Class['::profile::weblogic']
}
