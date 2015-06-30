class profile::docker::params {
  unless 'linux' == $::kernel {
    fail("Cannot create a docker host on kernel ${::kernel}!")
  }

  $default_images = {
    'ubuntu' => { 'ensure' => 'latest', },
    'centos' => { 'ensure' => 'latest', }
  }

  $default_runs = {
    'helloworld0' => { 'image' => 'ubuntu', command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"' },
    'helloworld1' => { 'image' => 'ubuntu', command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"' },
    'helloworld2' => { 'image' => 'ubuntu', command => '/bin/sh -c "while true; do echo hello world; sleep 1; done"' }
  }
}
