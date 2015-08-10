
class weblogic(
  $source,
  $wls_user = $::weblogic::params::default_wls_user,
  $wls_group = $::weblogic::params::default_wls_group,
  $staging_dir = $::weblogic::params::default_staging_dir,
  $install_dir = $::weblogic::params::default_install_directory,
  $inventory_dir = $::weblogic::params::default_inventory_dir,
  $gui_admin = $::weblogic::params::default_gui_admin
) inherits ::weblogic::params {

  multi_validate_re($source, $wls_user, $wls_group, '^.+$')
  validate_absolute_path($staging_dir, $install_dir, $inventory_dir)
  validate_bool($gui_admin)

  class { '::weblogic::staging': } ->
  class { '::weblogic::install': } ->
  class { '::weblogic::config': } ~>
  Class['::weblogic']
}
