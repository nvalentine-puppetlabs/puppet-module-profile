class profile::weblogic::staging(
  $source,
  $version = $::profile::weblogic::params::default_version
) inherits ::profile::weblogic::params {

  validate_re($source, '^.+$')
  validate_re("${version}", '^\d+$')
  
  require ::staging

  $filename = "wsl${version}_generic.jar"
  staging::file { "WebLogic ${version} installer":
    name => $filename,
    source  => $source,
    timeout => '3000',
  }

}
