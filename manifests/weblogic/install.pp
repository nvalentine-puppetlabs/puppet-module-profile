class profile::weblogic::install inherits ::profile::weblogic::params {

  $wls_user = $::profile::weblogic::params::default_wls_user
  $wls_group = $::profile::weblogic::params::default_wls_group

  multi_validate_re($wls_user, $wls_group, '^.+$')

  require ::jdk_oracle

  user { $wls_user: ensure => present, gid => $wls_group, }
  group { $wls_group: ensure => present, } ->
  
  exec { 'install Weblogic jar':
    path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin', '/usr/local/bin' ],
    cwd => '/tmp',
    command => "java -d64 -jar ${staging_dir}/weblogic-installer.jar",
    user => $wls_user,
    group => $wls_group,
  }
  
}
