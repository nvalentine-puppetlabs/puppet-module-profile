class profile::weblogic::allinone(
  $source,
  $weblogic_version = $::profile::weblogic::params::default_version,
) inherits ::profile::weblogic::params {

  $staging_dir = $::profile::weblogic::params::default_staging_dir
  $java_version = $::profile::weblogic::params::default_java_version
  $java_home = $::profile::weblogic::params::default_java_home
  $middleware_home = $::profile::weblogic::params::default_middleware_home
  $weblogic_home = $::profile::weblogic::params::default_weblogic_home
  $domain_user = $::profile::weblogic::params::default_wls_user
  $domain_password = $::profile::weblogic::params::default_wls_password
  $os_user = $::profile::weblogic::params::default_wls_user
  $os_group = $::profile::weblogic::params::default_wls_group

  multi_validate_re($source, $domain_password, $domain_user, '^.+$')
  multi_validate_re($os_user, $os_group, '^.+$')
  multi_validate_re("${weblogic_version}", "${java_version}", '^\d+$')
  validate_absolute_path($staging_dir, $java_home, $middleware_home, $weblogic_home)

  class { '::profile::weblogic::staging':
    source => $source,
    version => $weblogic_version,
  } ->

  class { '::profile::weblogic::install':
    version => $weblogic_version,
    staging_dir => $staging_dir,
  } ->
    
  Class['::profile::weblogic::allinone']

  ::orawls::domain { 'Domain default_domain':
    domain_name => 'default_domain',
    weblogic_user => $domain_user,
    os_user => $os_user,
    os_group => $os_group,
    weblogic_password => $domain_password,
    version => $weblogic_version,
    download_dir => $staging_dir,
    jdk_home_dir => "${java_home}/${java_version}/java_home",
    middleware_home_dir => $middleware_home,
    weblogic_home_dir => $weblogic_home,
    log_output => true,
    } ->

  ::orawls::nodemanager { 'NodeManager default_nodemanager':
    domain_name => 'default_domain',
    version => $weblogic_version,
    jdk_home_dir => "${java_home}/${java_version}/java_home",
    middleware_home_dir => $middleware_home,
    weblogic_home_dir => $weblogic_home,
    os_user => $os_user,
    os_group => $os_group,
    download_dir => $staging_dir,
    sleep => '30',
    log_output => true,
  } ->

  wls_adminserver { 'AdminServer default_domain':
    ensure => running,
    server_name => 'AdminServer',
    jdk_home_dir => "${java_home}/${java_version}/java_home",
    weblogic_home_dir => $weblogic_home,
    domain_path => "${weblogic_home}/user_projects/default_domain",
    domain_name => 'default_domain',
    nodemanager_address => 'localhost',
    nodemanager_port => '5556',
    os_user => $os_user,
    weblogic_user => $domain_user,
    weblogic_password => $domain_password,
  }
}

