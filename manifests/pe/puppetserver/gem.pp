define profile::pe::puppetserver::gem(
  $ensure = 'present',
) {

  validate_re($ensure, '^(absent|present|installed|[A-Za-z0-9\.\-\-])+$')

  case $ensure {
    'absent': {
      $action = 'uninstall'
      $command = "NOKOGIRI_USE_SYSTEM_LIBRARIES=1 /opt/puppet/bin/puppetserver gem uninstall ${name} -a"
      $check_command = "[ 'false' = $(/opt/puppet/bin/puppetserver gem list -i ${name}) ]"
    }
    
    /present|installed/ : {
      $action = 'install'
      $command = "NOKOGIRI_USE_SYSTEM_LIBRARIES=1 /opt/puppet/bin/puppetserver gem install ${name}"
      $check_command = "[ 'false' = $(/opt/puppet/bin/puppetserver gem list -i ${name}) ]"
    }

    /^[A-Za-z0-9\.\-\_]+$/: {
      $action = 'install'
      $version = $ensure
      $command = "NOKOGIRI_USE_SYSTEM_LIBRARIES=1 /opt/puppet/bin/puppetserver gem install ${name} -v ${version}"
      $check_command = "[ 'false' = $(/opt/puppet/bin/puppetserver gem list -i ${name} -v ${version}) ]"
    }

    default: {
     fail("Invalid valure for parameter 'ensure'!")
    }
  }


  exec { "install $name into context of puppetserver":
    path => $::path,
    command => $command,
    onlyif => $check_command,
    provider => shell,
    tries => 3,
    notify => Service['pe-puppetserver'],
  }

}
