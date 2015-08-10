class profile::weblogic::install(
  $version = $::profile::weblogic::params::default_version,
  $staging_dir = $::profile::weblogic::params::default_staging_dir,
  $oracle_home = $::profile::weblogic::params::default_oracle_home,
  $java_version = $::profile::weblogic::params::default_java_version,
  $java_home = $::profile::weblogic::params::default_java_home,
  $middleware_home = $::profile::weblogic::params::default_middleware_home,
  $wls_user = $::profile::weblogic::params::default_wls_user,
  $wls_group = $::profile::weblogic::params::default_wls_group
) inherits ::profile::weblogic::params {

  multi_validate_re($wls_user, $wls_group, '^.+$')
  multi_validate_re("${version}", "${java_version}", '^\d+$')
  validate_absolute_path($staging_dir, $oracle_home, $java_home, $middleware_home)

  $filename = "wsl${version}_generic.jar"

  group { $wls_group: ensure => present, }
  user { $wls_user: ensure => present, managehome => true, gid => $wls_group, }

  [$oracle_home, $java_home].each |$file| {
    file { $file:
      ensure => directory,
      owner => $wls_owner,
      group => $wls_group,
      mode => '0755',
      before => Class['::jdk_oracle'],
    }
  }

  class { '::jdk_oracle':
    version => $java_version,
    install_dir => "${java_home}/${java_version}",
    use_cache => true,
    timeout => 0,
  } ->
 
  class { '::orawls::weblogic':
    version => $version,
    filename => $filename,
    download_dir => $staging_dir,
    source =>  $staging_dir,
    remote_file => false,
    oracle_base_home_dir => $oracle_home,
    middleware_home_dir => $middleware_home,
    jdk_home_dir => "${java_home}/${java_version}",
    os_user => $wls_user,
    os_group => $wls_group,
  } ->

  class { '::profile::weblogic::baseconfig': }   
}
